# BGFit - Bacterial Growth Curve Fitting
# Copyright (C) 2012-2012  André Veríssimo
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2
# of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class ProxyDynaModel < ActiveRecord::Base
  belongs_to :measurement
  belongs_to :experiment
  belongs_to :dyna_model
  has_many :proxy_params, :dependent => :destroy
  has_one :simulation, as: :blobable, class_name: Blob.model_name
  
  accepts_nested_attributes_for :simulation
  
  attr_accessor :for_measurements
  
  validate :validate_title
  
  before_save :update_params
  
  has_paper_trail :skip => [:json]
  
  validates :dyna_model, :presence => { :message => 'A model must be choosen.' }
  
  scope :viewable, lambda { |user,only_mine=false| 
  }
  
  scope :experiment_is, lambda { |experiment|
    joins( :measurement ).where(Measurement.arel_table[:experiment_id].eq(experiment.id).or(ProxyDynaModel.arel_table[:experiment_id].eq(experiment.id)))
  }
  
  scope :dyna_model_is, lambda { |dyna_model|
    where( ProxyDynaModel.arel_table[:dyna_model_id].eq(dyna_model.id))
  }
  
  scope :measurement_is, lambda { |measurement|
    where( ProxyDynaModel.arel_table[:measurement_id].eq(measurement.id))  
  }
  
  ROUND = 5
  
  # Fulltext support using sunspot
  #searchable do
  #  text :title, :boost => 5 do
  #    title_join
  #  end
  #  text :description do
  #    dyna_model.description
  #  end
  #end

  #                                       bbbbbbbb                                                
  #                                       b::::::b            lllllll   iiii                      
  #                                       b::::::b            l:::::l  i::::i                     
  #                                       b::::::b            l:::::l   iiii                      
  #                                        b:::::b            l:::::l                             
  #  ppppp   ppppppppp   uuuuuu    uuuuuu  b:::::bbbbbbbbb     l::::l iiiiiii     cccccccccccccccc
  #  p::::ppp:::::::::p  u::::u    u::::u  b::::::::::::::bb   l::::l i:::::i   cc:::::::::::::::c
  #  p:::::::::::::::::p u::::u    u::::u  b::::::::::::::::b  l::::l  i::::i  c:::::::::::::::::c
  #  pp::::::ppppp::::::pu::::u    u::::u  b:::::bbbbb:::::::b l::::l  i::::i c:::::::cccccc:::::c
  #   p:::::p     p:::::pu::::u    u::::u  b:::::b    b::::::b l::::l  i::::i c::::::c     ccccccc
  #   p:::::p     p:::::pu::::u    u::::u  b:::::b     b:::::b l::::l  i::::i c:::::c             
  #   p:::::p     p:::::pu::::u    u::::u  b:::::b     b:::::b l::::l  i::::i c:::::c             
  #   p:::::p    p::::::pu:::::uuuu:::::u  b:::::b     b:::::b l::::l  i::::i c::::::c     ccccccc
  #   p:::::ppppp:::::::pu:::::::::::::::uub:::::bbbbbb::::::bl::::::li::::::ic:::::::cccccc:::::c
  #   p::::::::::::::::p  u:::::::::::::::ub::::::::::::::::b l::::::li::::::i c:::::::::::::::::c
  #   p::::::::::::::pp    uu::::::::uu:::ub:::::::::::::::b  l::::::li::::::i  cc:::::::::::::::c
  #   p::::::pppppppp        uuuuuuuu  uuuubbbbbbbbbbbbbbbb   lllllllliiiiiiii    cccccccccccccccc
  #   p:::::p                                                                                     
  #   p:::::p                                                                                     
  #  p:::::::p                                                                                    
  #  p:::::::p                                                                                    
  #  p:::::::p                                                                                    
  #  ppppppppp    
  
  public
  
    #
    # Overrided methods
    #
    
    # Overides title method to output a complex naming convention
    #
    def title_join
      title_pdm = read_attribute(:title)
      if title_pdm.blank? && !self.dyna_model.nil?
        self.dyna_model.title
      elsif self.dyna_model.nil?
        title_pdm
      else
        self.dyna_model.title + ': ' + title_pdm
      end
    end
    
    #
    # Recall Version
    def revert_to_version(timestamp)
      self.transaction do
        new_model = self.version_at(timestamp)
        new_model.updated_at = Time.now
        new_model.perform_clean_stats
        new_model.save
        new_model.proxy_params.each do |p|
          p.version_at(timestamp).save
        end
        new_model.json = nil
        new_model.json_cache # call solver and calculate statistical data
        return new_model
      end
    end
    
    #
    # Show unique versions, with different statistical values
    def show_versions
      list = self.versions.where(event: "update").collect do |v|
        if v.reify.rmse.nil?
          nil
        else
          v.reify
        end
      end
      
      list = list.compact.uniq_by do |u| 
        # create a unique string
        u.rmse.to_s + "|" + u.bias.to_s + "|" + u.accuracy.to_s + "|" + u.r_square.to_s
      end.sort_by(&:updated_at)
      
      list << self
    end
    
    #
    # Parameters to string
    def params_to_string(use_code=false)
      self.proxy_params.collect { |p|
        next if p.param.output_only?
        if use_code
          p.param.code + "=" + p.value.to_s
        else
          p.param.human_title + "=" + p.value.to_s
        end
      }.compact.join(", ")
    end
    
    # Does not allow to save data in this field 
    def original_data=(data) nil end
    
    # original_data field generates its content from current params
    #  (ignoring value that is stored in DB)
    def original_data
      string = ""
      self.proxy_params.collect { |param|
        string += param.code.to_s + " = "
        if param.code.nil?
          string += "<value>\n"
        else
          string += param.value.to_s + "\n"
        end
      }
      string
    end
    
    # Override to assure serialized hash is retrieved from db without changes in logic
    def json()
      return nil if self.simulation.nil? || self.simulation.data.nil?
      data = self.simulation.data
      return Marshal.load( data ) if (data).present?
      nil
    end
    
    # Override to assure hash is serialized to db without changes in logic
    def json=(value)
      self.simulation ||= Blob.new
      if value.nil?
        simulation.data = value
      else
        simulation.data = Marshal.dump( value )  
      end
      
    end
    
    
    # If json has not yet been calculated, then it calls solver method
    #
    # @return json results
    def json_cache(show_log=false)
      hash = :base10
      unless self.json.nil?
        logger.info {"[proxy_dyna_model.json_cache] json is in cache"}
        hash = :log_e if show_log && self.json.keys.include?(:log_e)
        return self.json[hash].to_s.gsub(/ /,"")
      end 
      if self.call_solver.nil?
        logger.info {"[proxy_dyna_model.json_cache] call to solver was nil"}
        return nil
      end 
      if self.statistical_data.nil?
        logger.info {"[proxy_dyna_model.json_cache] call to statistical_data was nil"}
        return
      end
      hash = :log_e if show_log && self.json.keys.include?(:log_e) 
      self.json[hash].to_s.gsub(/ /,"")
    end
    
    
    #
    # public methods for private
    #
    
    # Getter method for generating default estimation url
    def get_estimation_url() estimation_url(estimation_hash(temp_params)) end
    
    # Getter method for generating default solver url
    def get_solver_url() estimation_url(solver_url) end
    
    # Cleans statistical data
    def perform_clean_stats() clean_stats(nil) end
    
    # Prepares ProxyDynaModel to perform background calculation of parameters
    # TODO: move string to language file
    def call_pre_estimation_background_job() clean_stats "parameters are being calculated in background" end
    
    # Calls estimation using default parameters
    #  (see #call_estimation_with_custom_params)
    def call_estimation(is_post_method = true) call_estimation_with_custom_params( temp_params , is_post_method) end
    
    # Whether the model should show the results and regression in log scale
    def log_flag() dyna_model.log_flag end
    
    # default rounding for this class number or attributes
    def round(symbol) 
      begin
        (symbol.class == Symbol ? self.send(symbol) : symbol).round(ROUND)
      rescue
        nil
      end
    end
       
    #
    # Statistical methods
    # >>>>>>>>>>>>>>>>>>>
    #
    
    # bias standard deviation attribution
    def bias_stdev=(arg) @bias_stdev = arg end
    # bias standard deviation
    def bias_stdev() @bias_stdev end
    # accuracy standard deviation attribution    
    def accuracy_stdev=(arg) @accuracy_stdev = arg end
    # accuracy standard deviation
    def accuracy_stdev() @accuracy_stdev end
    # RMSE standard deviation attribution
    def rmse_stdev=(arg) @rmse_stdev = arg end
    # RMSE standard deviation attribution
    def rmse_stdev () @rmse_stdev end
    # R² standard deviation attribution
    def r_square_stdev=(arg) @r_square_stdev = arg end
    # R² standard deviation attribution
    def r_square_stdev () @r_square_stdev end
    
    def rmse_avg() @rmse_avg end
    def rmse_avg=(arg) @rmse_avg = arg end
    
    def bias_avg() @bias_avg end
    def bias_avg=(arg) @bias_avg = arg end
    
    def accuracy_avg() @accuracy_avg end
    def accuracy_avg=(arg) @accuracy_avg = arg end
    
    def r_square_avg() @r_square_avg end
    def r_square_avg=(arg) @r_square_avg = arg end
      
    #
    # calculates statiscal data:
    #  - RMSE
    #  - Accuracy factor
    #  - Bias Factor
    def statistical_data
      if ( measurement.nil? && experiment.nil? ) || self.json_cache.nil?
        # if proxy_dyna_model does not reference a measurement, then it showld not calculate
        logger.info {"[proxy_dyna_model.statistical_data]: #{measurement.nil?} (measurement.nil?) #{experiment.nil?} (experiment.nil?) #{json_cache.nil?} (json_cache.nil?)"}
        return nil
      end 
      
      # TODO death phase optional to dyna_model parameter
      size = 0
      
      dataset = {lines: nil , rmse: 0 , bias: 0 , accu: 0, r_square_tot: 0 , r_square_err: 0}
      #
      #
      #
      if measurement.nil?
        reference = experiment
        size = experiment_stats(dataset)
      else
        reference = measurement
        size = measurement_stats(dataset)
      end
      
      if size == 0
        return [].push("error")
      end
      self.bias = 10 ** (dataset[:bias] / size )
      self.accuracy = 10 ** (dataset[:accu] / size )
      self.rmse = Math.sqrt( dataset[:rmse] / size )
      if dataset[:r_square_tot] == 0
        "cannot calculate statistical_measures, try again with a different range."
        return nil
      end
      self.r_square = 1 - dataset[:r_square_err] / dataset[:r_square_tot]
      self.notes ||= ""
      self.save
      logger.info {"[proxy_dyna_model.statistical_data] statistical_data: #{self.rmse} (rmse) #{self.r_square} (r_square) #{self.bias} (bias) #{self.accuracy} (accuracy)"}
      begin
        [].push(reference.model.id).push(reference.model.title).push(reference.id).push( self.bias ).push( self.accuracy ).push( self.rmse  ).push( self.r_square )
      rescue
        [].push("n/a").push("n/a").push(reference.id).push( self.bias ).push( self.accuracy ).push( self.rmse  ).push( self.r_square )
      end
    end
    
    #
    # Parameter estimation methods
    # >>>>>>>>>>>>>>>>>>>
    #
    
    # Calls estimation using custom parameters
    #
    # @param params parameters' range that will be used in parameter estimation
    def call_estimation_with_custom_params(params,is_post_method=true)
      self.transaction do
        # if certain conditions are met this should not be done
        if (self.measurement.nil? && self.experiment.nil?) || 
          (self.dyna_model.estimation.nil?) || (self.dyna_model.estimation.blank?)
          errors.add(:base,'Error: Measurement is null.') if self.measurement.nil?
          errors.add(:base,'Error: Experiment is null.') if self.experiment.nil?
          errors.add(:base,'Error: Estimation url is blank.') if self.dyna_model.estimation.nil? || self.dyna_model.estimation.blank? 
          return
        end
        
        request_hash = estimation_hash( params )
        begin
          if is_post_method
            response = call_http_post(request_hash)
          else
            response = call_http_get(request_hash)
          end    
          if response.body.blank?
            clean_stats "empty response"
            return
          end
        
        rescue Timeout::Error => e
          # TODO: locale it!
          clean_stats "timeout while calculating parameters, try again", e
        rescue StandardError::SocketError => e
          clean_stats "cannot access dyna model, try again in a while and make sure the url is accessible", e
        else
          handle_http_response(response,params)
        end
      end
    end
    
    # handle http response for parameter estimation
    def handle_http_response(response,params)
      begin
        result = JSON.parse( response.body.gsub(/(\n|\t| )/,'') )
      rescue JSON::ParserError => e
          self.json = nil
          # TODO: locale it!
          clean_stats('Error: Error when calling estimator.',e)
          return
      end
      if result["error"]
        self.json = nil
        clean_stats(result["error"])
        return
      end
      self.proxy_params.each do |d_p|
        d_p.value = result[d_p.param.code] if !result[d_p.param.code].nil?
        temp_param = params.find { |par| par.id == d_p.param_id }

        d_p.top = temp_param.top
        d_p.bottom = temp_param.bottom
        d_p.save
        d_p
      end
      self.json = nil
      self.json_cache # call solver and calculate statistical data
    end

    #
    # Simulation methods
    # >>>>>>>>>>>>>>>>>>>
    #

    # Calls the solver for the calculated parameters
    #
    # @param time [int] safety measure allowing to adjust timescale in solver in case of errors
    def call_solver(time=nil)
      self.transaction do
        request_hash = solver_url(time)
        # TODO better handle this
        if request_hash.nil?
          logger.info {"[proxy_dyna_model.call_solver]: request hash is nil"}
          return
        end 
  
        begin    
          response = call_http_get(request_hash)
        rescue Timeout::Error => e
          self.notes = "timeout while simulating, try again"
          logger.info {"[proxy_dyna_model.call_solver]: #{self.notes} + #{e.message}"}
          self.json = nil
          self.save
          return
        rescue URI::InvalidURIError => e
          logger.info {"[proxy_dyna_model.call_solver]: invalid URI + #{e.message}"}
          self.json = nil
          self.save
          return
        end
        temp_json = JSON.parse( response.body.gsub(/(\n|\t)/,'') )
        if temp_json["error"]
            clean_stats( "Error while simulating data: " + temp_json["error"].to_s )
        elsif temp_json["result"]
          self.notes = nil
          self.notes = "\"-Inf\" or \"Inf\" values have been detected and were removed from curve" unless (temp_json["result"].reject!{ |q| q[1]=='-_Inf_' || q[1]=='_Inf_'  }).nil?
          temp_json["result"].reject!{ |q| q[1]=='_NaN_'  }
          h_json = {}
          if self.log_flag
            h_json[:log_e] = temp_json["result"]
            h_json[:base10] = temp_json["result"].map { |data| [data[0],Math.exp(data[1])] }
            self.json = h_json
          else
            h_json[:base10] = temp_json["result"]
            self.json = h_json
          end
          #self.json = temp_json["result"].to_s.gsub(/ /,'')
        else
          clean_stats( "Error while simulating data" )
        end
        self.save
        self.json
      end
    end
    
    #
    def convert_param(original_args)
      flag = false
      self.proxy_params.each { |param|
        temp = /#{param.code} = (?<value>[-]?[0-9]+[.]?[0-9]*)/.match(original_args)
        if temp
          param.value = temp[:value]
          flag = true if param.save
        end
      }    
      self.call_solver if flag
      statistical_data if flag
    end

    #
    def update_params(no_commit = false)
      
      params = self.proxy_params
      
      dyna_params = self.dyna_model.params
      
      dyna_params.collect { |d_p|
        
        list = nil
        list = params.find_all { |p|
          p.param_id == d_p.id
        }
        if list.length == 0
          new_param = self.proxy_params.build
          new_param.param = d_p
          new_param.value = nil
          
          new_param.save unless no_commit
          
          new_param
        else
          # TODO: check if should be "list.first.custom_init"
          list.each{ |p| p.custom_init }
          list.first
        end
      }
     
    end

    #
    # Authorization methods
    # >>>>>>>>>>>>>>>>>>>
    #


    def can_view(user=nil)
      if measurement.present?
        measurement.experiment.model.can_view(user)
      else
        experiment.model.can_view(user)
      end
    end
    
    def can_edit(user=nil)
      if measurement.present?
        measurement.experiment.model.can_edit(user)
      else
        experiment.model.can_edit(user)
      end
    end



    def simulated_values
      if self.measurement
        simulated_lines( self.measurement.lines_no_death_phase(no_death_phase) )
      elsif self.experiment
        self.experiment.measurements.collect do |m|
          simulated_lines m.lines_no_death_phase(no_death_phase)
        end.compact.flatten(1).sort!{|a,b| a[0]<=>b[0]}
      end
    end

  #
  #                                           iiii                                                  tttt                              
  #                                          i::::i                                              ttt:::t                              
  #                                           iiii                                               t:::::t                              
  #                                                                                              t:::::t                              
  #  ppppp   ppppppppp   rrrrr   rrrrrrrrr  iiiiiiivvvvvvv           vvvvvvvaaaaaaaaaaaaa  ttttttt:::::ttttttt        eeeeeeeeeeee    
  #  p::::ppp:::::::::p  r::::rrr:::::::::r i:::::i v:::::v         v:::::v a::::::::::::a t:::::::::::::::::t      ee::::::::::::ee  
  #  p:::::::::::::::::p r:::::::::::::::::r i::::i  v:::::v       v:::::v  aaaaaaaaa:::::at:::::::::::::::::t     e::::::eeeee:::::ee
  #  pp::::::ppppp::::::prr::::::rrrrr::::::ri::::i   v:::::v     v:::::v            a::::atttttt:::::::tttttt    e::::::e     e:::::e
  #   p:::::p     p:::::p r:::::r     r:::::ri::::i    v:::::v   v:::::v      aaaaaaa:::::a      t:::::t          e:::::::eeeee::::::e
  #   p:::::p     p:::::p r:::::r     rrrrrrri::::i     v:::::v v:::::v     aa::::::::::::a      t:::::t          e:::::::::::::::::e 
  #   p:::::p     p:::::p r:::::r            i::::i      v:::::v:::::v     a::::aaaa::::::a      t:::::t          e::::::eeeeeeeeeee  
  #   p:::::p    p::::::p r:::::r            i::::i       v:::::::::v     a::::a    a:::::a      t:::::t    tttttte:::::::e           
  #   p:::::ppppp:::::::p r:::::r           i::::::i       v:::::::v      a::::a    a:::::a      t::::::tttt:::::te::::::::e          
  #   p::::::::::::::::p  r:::::r           i::::::i        v:::::v       a:::::aaaa::::::a      tt::::::::::::::t e::::::::eeeeeeee  
  #   p::::::::::::::pp   r:::::r           i::::::i         v:::v         a::::::::::aa:::a       tt:::::::::::tt  ee:::::::::::::e  
  #   p::::::pppppppp     rrrrrrr           iiiiiiii          vvv           aaaaaaaaaa  aaaa         ttttttttttt      eeeeeeeeeeeeee  
  #   p:::::p                                                                                                                         
  #   p:::::p                                                                                                                         
  #  p:::::::p                                                                                                                        
  #  p:::::::p                                                                                                                        
  #  p:::::::p                                                                                                                        
  #  ppppppppp        
  #  
 
  private
  
    # Validation if title is unique to the combination:
    #  - Measurement
    #  - DynaModel
    #  - ProxyDynaModel.title
    # @return [int] validation
    def validate_title
      t = ProxyDynaModel.arel_table
      result = ProxyDynaModel.where( t[:dyna_model_id].eq(self.dyna_model_id).and(t[:title].eq(self.title) ).and(t[:id].not_eq(self.id)).and(t[:measurement_id].eq(self.measurement_id).and(t[:experiment_id].eq(self.experiment_id))) ).size
      errors.add(:title, "choose another title, as it is already identifies a model for this measurement and dynamic model.") if result > 0
    end
  
    # Clean statistical information from the object in one transaction
    #
    # @param note [String] a note that will be saved with an error/warning/info
    def clean_stats(note,exception=nil)
      logger.info {"[proxy_dyna_model.clean_stats]: #{note}. #{if exception.present? then exception.message end}"}
      self.transaction do
        self.json = nil
        self.rmse = nil
        self.bias = nil
        self.r_square = nil
        self.accuracy = nil
        self.notes = note
        self.proxy_params.each do |p| 
          p.value = nil; 
          p.top = nil; 
          p.bottom = nil;
          p.save;
        end
        self.save
      end
    end
    
    # get solver url with parameters
    def solver_url(time=nil)
      hash = {}
      hash[:url] = self.dyna_model.solver
      self.proxy_params.each { |p|
        next if p.code == 'o'
        return nil if p.value.nil?      
        hash[p.param.code]=p.value.to_s
      }
      
      if self.measurement.present?
        # measurement
        hash[:start] =  self.measurement.lines.order(:x).first.x
        if  time.nil?
          hash[:end] = self.measurement.end(self.no_death_phase).to_s
        else
          hash[:end] = (self.measurement.end(self.no_death_phase)-time).to_s
        end
        hash[:minor_step] = self.measurement.minor_step_cache.to_s unless self.measurement.minor_step_cache.nil? || self.measurement.minor_step_cache == 0  
      else
        # experiments
        lines_aux = self.experiment.measurements.collect{|m|m.lines_no_death_phase(self.no_death_phase)}.flatten
        hash[:start] = lines_aux.min_by { |l| l.x }.x
        hash[:end] = lines_aux.max_by { |l| l.x }.x
        minor_step = self.experiment.measurements.select(Measurement.arel_table[:minor_step].minimum.as("min_minor_step")).first.min_minor_step
        hash[:minor_step] = minor_step if minor_step.present? || minor_step == 0
      end
      hash
    end
    
    # Convert single parameter to url ready
    def param_to_url( code, top , bottom )
      CGI::escape("{\"name\"")   + ":" + CGI::escape("\"") + "#{code}"  + CGI::escape("\"") + "," +
      CGI::escape("\"bottom\"") + ":"  + "#{bottom}"    + "," +
      CGI::escape("\"top\"")    + ":"  + "#{top}" + CGI::escape("}")
    end
    
    # Builds hash with time and respective values array
    #  (i.e. x and y columns)
    def time_and_values
      
      # TODO make death phase optional
      if self.experiment.nil?
        x_array = self.measurement.x_array(log_flag,no_death_phase)
        y_array = self.measurement.y_array(log_flag,no_death_phase)
      else
        x_array = experiment.measurements.collect { |m|
          m.x_array(log_flag,no_death_phase).to_s
        }.join('];[')
        
        y_array = experiment.measurements.collect { |m|
          m.y_array(log_flag,no_death_phase).to_s
        }.join('];[')
     
      end
      #return "time=[#{x_array}]&values=[#{y_array}]"          
      return { time: "[#{x_array}]" , values: "[#{y_array}]" }
    end
    
    # URL parameters (that map against states in SBTOOLBOX2)
    def build_estimation_ranges(params)
      uri_params = { names: [] , top: [] , bottom: [] }
      
      params.each { |p|
        next if p.output_only || p.initial_condition
        if p.top.nil? || p.bottom.nil?
          raise Exception.new(p.human_title.html_safe + " does not have top/bottom values")
        else
          uri_params[:names] << p.code
          uri_params[:top] << p.top
          uri_params[:bottom] << p.bottom
        end 
      }
      uri_params
    end
    
    # Converts an array of strings to a URI-ready query
    #  with '"' removed, as well as whitespace
    def arrayOfStrings2query( array , doEscape = false)
      if doEscape
        CGI.escape array.to_s.tr('\" ','')
      else
        array.to_s.tr('\" ','')
      end
    end
    
    # URL initial conditions (that map against initial conditions in SBTOOLBOX2)
    def build_ic(params)
      ic_flag = false;
      uri_params = { names: [] , top: [] , bottom: [] }
    
      params.each { |p|
        next unless p.initial_condition
        raise Exception.new(p.human_title.html_safe + " does not have top/bottom values") if p.top.nil? || p.bottom.nil?
        uri_params[:names] << p.code
        uri_params[:top] << p.top
        uri_params[:bottom] << p.bottom
        ic_flag = true
      }
      return nil unless ic_flag
      #if ic_flag
      #  uri_params[:names] << 't'
      #  uri_params[:top] << measurement.end(self.no_death_phase)
      #  uri_params[:bottom] << 0
      #end
      uri_params
    end
    
    # Calls URL using get method for the given url 
    #
    # @param url indicates the web address
    def call_http_get(request_hash)
      uri = URI(estimation_url(request_hash))
     
      logger.info {"[proxy_dyna_model.call_http_get] #{uri.to_s}"}
      
      request = Net::HTTP::Get.new uri.request_uri
      res = call_http_generic( uri , request )
    end
    
    def call_http_post(request_hash)
      uri = URI(request_hash.delete(:url))
      
      logger.info {"[proxy_dyna_model.call_http_post] #{uri.to_s} / form: #{request_hash.inspect}"} 
      request = Net::HTTP::Post.new uri.request_uri
      request.set_form_data(request_hash)
      res = call_http_generic( uri , request )
    end
    
    def call_http_generic(uri, request)
      res = Net::HTTP.start(uri.host, uri.port) {|http|
        timeout = 1540
        http.open_timeout = timeout
        http.read_timeout = timeout
        http.request request
      }

    end
    
    # get 
    def estimation_hash( params )
      
      tv = time_and_values
      states = build_estimation_ranges(params)
      ic = build_ic(params)
      
      hash = {}
      hash[:url] = self.dyna_model.estimation
      hash[:param_names] = arrayOfStrings2query states[:names]
      hash[:param_top] = arrayOfStrings2query states[:top]
      hash[:param_bottom] = arrayOfStrings2query states[:bottom]
      
      unless ic.nil?
        hash[:ic_names] = arrayOfStrings2query arrayOfStrings2query ic[:names]
        hash[:ic_top] = arrayOfStrings2query ic[:top]
        hash[:ic_bottom] = arrayOfStrings2query ic[:bottom]
      end
      
      hash[:time] = arrayOfStrings2query tv[:time]
      hash[:values] = arrayOfStrings2query tv[:values]
      
      hash
    end
    
    # get solver url with parameters
    def estimation_url( request_hash )
      unless request_hash.has_key?(:url)
        errors.add(:base,'Error: url was not given.')
        logger.error {"[proxy_dyna_model.estimation_url] Error: url was not given: #{request_hash.inspect}"}
        return
      end
      url = "#{request_hash.delete(:url)}"
      url += '?' if request_hash.size > 1
      url += request_hash.collect { |key, value|
        "#{key.to_s}=#{arrayOfStrings2query value.to_s}"
      }.join('&')
      
      #"#{request_hash[:url]}?time=#{request_hash[:time]}&values=#{request_hash[:values]}&estimation=#{request_hash[:states]}"
    end
    #
    #
    #
    def temp_params
      # TODO: refactor to use proxy dyna model proxy params directly
      params = self.proxy_params.collect do |p|
        p.param.bottom = p.bottom_cache
        p.param.top = p.top_cache
        p.param
      end
    end
    #
    #                            tttt                                    tttt                           
    #                         ttt:::t                                 ttt:::t                           
    #                         t:::::t                                 t:::::t                           
    #                         t:::::t                                 t:::::t                           
    #      ssssssssss   ttttttt:::::ttttttt      aaaaaaaaaaaaa  ttttttt:::::ttttttt        ssssssssss   
    #    ss::::::::::s  t:::::::::::::::::t      a::::::::::::a t:::::::::::::::::t      ss::::::::::s  
    #  ss:::::::::::::s t:::::::::::::::::t      aaaaaaaaa:::::at:::::::::::::::::t    ss:::::::::::::s 
    #  s::::::ssss:::::stttttt:::::::tttttt               a::::atttttt:::::::tttttt    s::::::ssss:::::s
    #   s:::::s  ssssss       t:::::t              aaaaaaa:::::a      t:::::t           s:::::s  ssssss 
    #     s::::::s            t:::::t            aa::::::::::::a      t:::::t             s::::::s      
    #        s::::::s         t:::::t           a::::aaaa::::::a      t:::::t                s::::::s   
    #  ssssss   s:::::s       t:::::t    tttttta::::a    a:::::a      t:::::t    ttttttssssss   s:::::s 
    #  s:::::ssss::::::s      t::::::tttt:::::ta::::a    a:::::a      t::::::tttt:::::ts:::::ssss::::::s
    #  s::::::::::::::s       tt::::::::::::::ta:::::aaaa::::::a      tt::::::::::::::ts::::::::::::::s 
    #   s:::::::::::ss          tt:::::::::::tt a::::::::::aa:::a       tt:::::::::::tt s:::::::::::ss  
    #    sssssssssss              ttttttttttt    aaaaaaaaaa  aaaa         ttttttttttt    sssssssssss    
    #
    
    # Helper methods for statistical calculations
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    #
    
    # helper method to calculate statistical for experiment
    def experiment_stats(dataset)
      logger.info {"[proxy_dyna_model.experiment_stats] Calculating stats for proxy_dyna_model (#{self.id})"}
      size = 0
      experiment.measurements.each do |m|
        dataset[:lines] = m.lines_no_death_phase(no_death_phase)
        size += dataset[:lines].size
        dataset = statistical_data_measurement( dataset )
      end
      logger.info {"[proxy_dyna_model.experiment_stats] #{dataset.inspect}"}
      size
    end
    
    # helper method to calculate statistical for measurement
    #
    def measurement_stats(dataset)
      logger.info {"[proxy_dyna_model.measurement_stats] Calculating stats for proxy_dyna_model (#{self.id})"}
      size = 0
      dataset[:lines] = measurement.lines_no_death_phase(no_death_phase)
      size += dataset[:lines].size
      dataset = statistical_data_measurement( dataset )
      logger.info {"[proxy_dyna_model.measurement_stats] #{dataset.inspect}"}
      size
    end
    
   
    # helper method that calculates statistical data for a measurement
    #  in case it is a complex structure (i.e. experiment), then it will
    #  use introduce the values for the hash
    #
    # @see #statistical_data
    def statistical_data_measurement( hash )
      json_parsed = json[:base10] # array of [x,y]
      
      begin
        simulated_value = json_parsed.shift
        prev_sim_value = nil
        # cycle that covers all lines in hash

        hash[:lines].each do |line|
          # cycle that finds next simulated value
          while simulated_value.present? && simulated_value[0] < line.x
            prev_sim_value = simulated_value
            simulated_value = json_parsed.shift # pops first element of json_parsed
          end
          logger.error "[proxy_dyna_model.statistical_data_measurement] simulated_value is nil at line.x = " + line.x.to_s if simulated_value.nil?
          # checks if current simulated value timepoint is greater or equal than timepoint
          value = nil
          if simulated_value[0] > line.x
            #  if it is greater then averages weighted simulated value with previous
            difference = (simulated_value[0] - prev_sim_value[0]).abs
            prev_weight = (line.x - prev_sim_value[0]).abs / difference
            next_weight = (line.x - simulated_value[0]).abs / difference
            value = prev_weight * prev_sim_value[1] + next_weight * simulated_value[1]
          else
            # if timepoint is equal then it uses y value 
            value = simulated_value[1]
          end
          if @y_mean.nil?
            @y_mean = 0
            lines = self.measurement.lines_no_death_phase() if self.measurement.present?
            lines = self.experiment.measurements.collect(&:lines_no_death_phase).flatten if self.experiment.present?
            lines.each{ |el| @y_mean += el.y_value() }
            @y_mean = @y_mean.to_f / lines.size 
          end
          hash[:rmse] +=  ( value - line.y_value() ) ** 2
          hash[:r_square_err] = hash[:rmse] 
          hash[:r_square_tot] += ( line.y_value() - @y_mean ) ** 2
          hash[:bias] = Math.log( (value / line.y_value()).abs ).abs
          hash[:accu] = Math.log( (value / line.y_value()).abs )          
        end
      
      rescue Exception,NoMethodError  => e
        #raise e
        logger.error "[proxy_dyna_model.statistical_data_measurement] error: " + e.message
        
        #clean_stats "error while calculating statistics"
        return [].push(self.id).push(-1)
      end
      return hash
    end
    
    def simulated_lines(lines)
      begin
        json_parsed = json[:base10] # array of [x,y]
        simulated_value = json_parsed.shift
        prev_sim_value = nil
        # cycle that covers all lines in hash
        result = lines.collect do |line|
          # cycle that finds next simulated value
          while simulated_value.present? && simulated_value[0] < line.x
            prev_sim_value = simulated_value
            simulated_value = json_parsed.shift # pops first element of json_parsed
          end
          logger.error "[proxy_dyna_model.simulated_lines] simulated_value is nil" if simulated_value.nil?
          # checks if current simulated value timepoint is greater or equal than timepoint
          value = nil
          if simulated_value[0] > line.x
            #  if it is greater then averages weighted simulated value with previous
            difference = (simulated_value[0] - prev_sim_value[0]).abs
            prev_weight = (line.x - prev_sim_value[0]).abs / difference
            next_weight = (line.x - simulated_value[0]).abs / difference
            value = prev_weight * prev_sim_value[1] + next_weight * simulated_value[1]
          else
            # if timepoint is equal then it uses y value 
            value = simulated_value[1]
          end
          [line.x , line.y_value , value]
        end
        result
      rescue Exception => e
          logger.error "[proxy_dyna_model.simulated_lines] " + e.message
          nil
      end
      
    end
  
  
end

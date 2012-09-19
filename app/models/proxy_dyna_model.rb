class ProxyDynaModel < ActiveRecord::Base
  belongs_to :measurement
  belongs_to :experiment
  belongs_to :dyna_model
  has_many :proxy_params, :dependent => :destroy
  
  validate :validate_title
  
  before_create :update_params
  before_update :update_params
  
  has_paper_trail :skip => [:json]
  
  
  
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
    def title
      if read_attribute(:title).nil? && !self.dyna_model.nil?
        self.dyna_model.title
      elsif self.dyna_model.nil?
        read_attribute(:title)
      else
        self.dyna_model.title + ': ' + read_attribute(:title)
      end
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
    
    #
    # public methods for private
    #
    
    # Getter method for generating default estimation url
    def get_estimation_url() estimation_url(temp_params) end
    # Getter method for generating default solver url
    def get_solver_url() solver_url end
    # Cleans statistical data
    def perform_clean_stats() clean_stats(nil) end
    # Prepares ProxyDynaModel to perform background calculation of parameters
    # TODO: move string to language file
    def call_pre_estimation_background_job() clean_stats "parameters are being calculated in background" end
    # Calls estimation using default parameters
    #  (see #call_estimation_with_custom_params)
    def call_estimation() call_estimation_with_custom_params( temp_params ) end
      
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
    
    #
    # calculates statiscal data:
    #  - RMSE
    #  - Accuracy factor
    #  - Bias Factor
    def statistical_data
      return nil if ( measurement.nil? && experiment.nil? ) || self.json_cache.nil?   # if proxy_dyna_model does not reference a measurement, then it showld not calculate
      
      # TODO death phase optional to dyna_model parameter
      size = 0
      
      dataset = {lines: nil , rmse: 0 , bias: 0 , accu: 0}
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
      
      self.bias = 10 ** (dataset[:bias] / size )
      self.accuracy = 10 ** (dataset[:accu] / size )
      self.rmse = Math.sqrt( dataset[:rmse] / size )
      self.notes = ""
      self.save
      [].push(reference.model.id).push(reference.model.title).push(reference.id).push( self.bias ).push( self.accuracy ).push( self.rmse  )
    end
    
    # Calls estimation using custom parameters
    #
    # @param params parameters' range that will be used in parameter estimation
    def call_estimation_with_custom_params(params)
      # if certain conditions are met this should not be done
      # TODO add verbose error
      return unless !(self.measurement.nil?) || !(self.experiment.nil?) || !(self.dyna_model.estimation.nil?) || !(self.dyna_model.estimation == "")
      
      url = estimation_url( params )
      print "\n" + url.to_s + "\n\n"
      begin
        response = call_http_get(url)    
        
        if response.body.blank?
          clean_stats "empty response"
          return
        end
      
      rescue Timeout::Error => e
        clean_stats "timeout while calculating parameters, try again"
        return
      end
      begin
        result = JSON.parse( response.body.gsub(/(\n|\t)/,'') )
      rescue JSON::ParserError
        self.transaction do
          self.json = nil
          clean_stats('Error: Error when calling estimator.')
          return
        end 
      end
      if result["error"]
        self.transaction do
          self.json = nil
          clean_stats(result["error"])
          return
        end
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
    
    # If json has not yet been calculated, then it calls solver method
    #
    # @return json results
    def json_cache
      return self.json unless self.json.nil?
      return nil if self.call_solver.nil?
      self.statistical_data 
      self.json
    end
    
    # Calls the solver for the calculated parameters
    #
    # @param time [int] safety measure allowing to adjust timescale in solver in case of errors
    def call_solver(time=nil)
          
      url = solver_url(time)
      
      print url.to_s + "\n\n"  
      begin    
        response = (url)
     rescue Timeout::Error
        self.notes = "timeout while simulating, try again"
        self.json = nil
        self.save
        return
      rescue URI::InvalidURIError
        self.json = nil
        self.save
        return
      end
      temp_json = JSON.parse( response.body.gsub(/(\n|\t)/,'') )
      if temp_json["error"]
	      print 'time: ' + time.to_s unless time.nil?
        if time.nil?
          call_solver(1)
          return self.json
        elsif (self.measurement.end - time < 0 )
          self.notes = "error while simulating data" + temp_json["error"].to_s
          self.json = nil
        else
          call_solver(time+1)
          return self.json
        end
      else
        self.notes = "\"-Inf\" or \"Inf\" values have been detected and were removed from curve" if temp_json["result"].reject!{ |q| q[1]=='-_Inf_' || q[1]=='_Inf_'  }.nil?
        self.json = temp_json["result"].to_s
      end
      self.save
      self.json
    end
    
    #
    def convert_param(original_args)
      flag = false
      self.proxy_params.each { |param|
        temp = /#{param.code} = (?<value>[0-9]+[.]?[0-9]*)/.match(original_args)
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
      result = ProxyDynaModel.where( t[:dyna_model_id].eq(self.dyna_model_id).and(t[:title].eq(self.title) ).and(t[:id].not_eq(self.id)).and(t[:measurement_id].eq(self.measurement_id)) ).size
      errors.add(:title, "choose another title, as it is already identifies a model for this measurement and dynamic model.") if result > 0
    end
  
    # Clean statistical information from the object in one transaction
    #
    # @param note [String] a note that will be saved with an error/warning/info
    def clean_stats(note)
      self.transaction do
        self.json = nil
        self.rmse = nil
        self.bias = nil
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
      url_params = self.proxy_params.collect { |p|
        next if p.code == 'o'
        return nil if p.value.nil?      
        "#{p.param.code}=#{p.value.to_s}"
      }.compact.join('&')
      
      if self.measurement.nil?
        url = "#{self.dyna_model.solver}?#{url_params}&end=#{self.measurement.end(self.no_death_phase).to_s}"
      else
        if time.nil?
          url = "#{self.dyna_model.solver}?#{url_params}&#{self.measurement.end_title}=#{self.measurement.end(self.no_death_phase).to_s}"
        else
          url = "#{self.dyna_model.solver}?#{url_params}&#{self.measurement.end_title}=#{(self.measurement.end(self.no_death_phase)-time).to_s}"
        end
      end
      url
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
        x_array = self.measurement.x_array(false,no_death_phase)
        y_array = self.measurement.y_array(log_flag,no_death_phase)
      else
        x_array = experiment.measurements.collect { |m|
          m.x_array(false,no_death_phase).to_s
        }.join('];[')
        
        y_array = experiment.measurements.collect { |m|
          m.y_array(log_flag,no_death_phase).to_s
        }.join('];[')
     
      end
      #return "time=[#{x_array}]&values=[#{y_array}]"          
      return { time: "[#{x_array}]" , values: "[#{y_array}]" }
    end
    
    # URL parameters (that map against states in SBTOOLBOX2)
    def build_estimation(params)
      url_states = CGI::escape("{\"states\"") + ":[" + params.collect { |p|
        next if p.output_only || p.initial_condition
        if p.top.nil? || p.bottom.nil?
          raise Exception.new(p.human_title.html_safe + " does not have top/bottom values")
        else
          param_to_url( p.code , p.top, p.bottom )
        end 
      }.compact.join(',') + "]"
      url_states += url_ic unless (url_ic = build_ic(params)).nil?
      url_states += CGI::escape("}")
    end
    
    # URL initial conditions (that map against initial conditions in SBTOOLBOX2)
    def build_ic(params)
      ic_flag = false;
      url_ic = "," + CGI::escape("\"initial\"") + ":["
      url_ic += params.collect { |p|
        next unless p.initial_condition
        raise Exception.new(p.human_title.html_safe + " does not have top/bottom values") if p.top.nil? || p.bottom.nil?
        param_to_url( p.code , p.top, p.bottom )
        ic_flag = true;
      }.compact.join(',') + ',' + 
        param_to_url( "t" , measurement.end(self.no_death_phase).to_s , "0" ) + "]" # adds time
      
      return nil unless ic_flag
      url_ic
    end
    
    #
    #
    #
    #
    def call_http_get(url)
      uri = URI(url)
      
      request = Net::HTTP::Get.new uri.request_uri
      res = Net::HTTP.start(uri.host, uri.port) {|http|
        timeout = 1540
        http.open_timeout = timeout
        http.read_timeout = timeout
        http.request request
      }
    end
    
    def estimation_params( params )
      
      
      
    end
    
    # get solver url with parameters
    def estimation_url( params )
    
      tv = time_and_values
    
      url = "#{self.dyna_model.estimation}?time=#{tv[:time]}&values=#{tv[:values]}"
      
      url_states = build_estimation(params)
  
      url += '&estimation=' + url_states
      url
    end
    #
    #
    #
    def temp_params
      # TODO: refactor to use proxy dyna model proxy params directly
      params = self.proxy_params.collect do |p|
        p.param.bottom = p.bottom
        p.param.top = p.top
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
      size = 0
      experiment.measurements.each do |m|
        dataset[:lines] = m.lines_no_death_phase(self.no_death_phase)
        size += dataset[:lines].size
        dataset = statistical_data_measurement( dataset )
      end
      size
    end
    
    # helper method to calculate statistical for measurement
    #
    def measurement_stats(dataset)
      size = 0
      dataset[:lines] = measurement.lines_no_death_phase(self.no_death_phase)
      size += dataset[:lines].size
      dataset = statistical_data_measurement( dataset )
      size
    end
    
    # helper method that calculates statistical data for a measurement
    #  in case it is a complex structure (i.e. experiment), then it will
    #  use introduce the values for the hash
    #
    # @see #statistical_data
    def statistical_data_measurement( hash )
      line = hash[:lines].shift
      old = line.y_value(log_flag)
      begin
        JSON.parse(self.json).each do |pair|
          break if line.nil?
          next if pair[1]<= 0
          #
          if pair[0] >= line.x
            pair[1] = ( old + pair[1] ) / 2 if pair[0] > line.x
            hash[:rmse] +=  ( pair[1] - line.y_value(log_flag) ) ** 2
            hash[:bias] = Math.log( (pair[1] / line.y_value(log_flag)).abs ).abs
            hash[:accu] = Math.log( (pair[1] / line.y_value(log_flag)).abs )
            line = hash[:lines].shift  
          else
            old = pair[1]
            nil
          end
        end
      rescue Exception => e
        clean_stats "error while calculating statistics"
        return [].push(measurement.id).push(-1)
      end
      return hash
    end
  
  
  
  
end

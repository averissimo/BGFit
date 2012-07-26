class ProxyDynaModel < ActiveRecord::Base
  belongs_to :measurement
  belongs_to :experiment
  belongs_to :dyna_model
  has_many :proxy_params, :dependent => :destroy
  
  before_create :update_params
  before_update :update_params
  
  has_paper_trail :skip => [:json]
  
  public
  
    # bias standard deviation attribution
    def bias_stdev=(arg)
      @bias_stdev = arg
    end
    # bias standard deviation
    def bias_stdev
      @bias_stdev
    end
    # accuracy standard deviation attribution    
    def accuracy_stdev=(arg)
      @accuracy_stdev = arg
    end
    # accuracy standard deviation
    def accuracy_stdev
      @accuracy_stdev
    end
    # RMSE standard deviation attribution
    def rmse_stdev=(arg)
      @rmse_stdev = arg
    end
    # RMSE standard deviation attribution
    def rmse_stdev
      @rmse_stdev
    end
    
    def get_estimation_url
      estimation_url(self.dyna_model.params)
    end
    
    def get_solver_url
      solver_url
    end
    
    # calculates statiscal data:
    #  - RMSE
    #  - Accuracy factor
    #  - Bias Factor
    
    def experiment_stats(dataset)
      size = 0
      experiment.measurements.each do |m|
        dataset[:lines] = m.lines_no_death_phase
        size += dataset[:lines].size
        dataset = statistical_data_measurement( dataset )
      end
      size
    end
    
    def measurement_stats(dataset)
      size = 0
      dataset[:lines] = measurement.lines_no_death_phase
      
      size += dataset[:lines].size
      
      dataset = statistical_data_measurement( dataset )
      size
    end
    
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
      self.rmse = Math.sqrt ( dataset[:rmse] / size )
      self.notes = ""
      self.save
      [].push(reference.model.id).push(reference.model.title).push(reference.id).push( self.bias ).push( self.accuracy ).push( self.rmse  )
    end
    
    def statistical_data_measurement( hash )
      
      line = hash[:lines].shift
      old = line.y
      
      
      begin
        JSON.parse(self.json).each do |pair|
          break if line.nil?
          next if pair[1]<= 0
          #
          if pair[0] >= line.x
            pair[1] = ( old + pair[1] ) / 2 if pair[0] > line.x
            hash[:rmse] +=  ( pair[1] - line.y ) ** 2
            hash[:bias] = Math.log( pair[1] / line.y ).abs
            hash[:accu] = Math.log( pair[1] / line.y )
            line = hash[:lines].shift  
          else
            old = pair[1]
            nil
          end
        end
      rescue Exception => e  
        debugger
        clean_stats "error while calculating statistics"
        return [].push(measurement.id).push(-1)
      end
      return hash
      
    end
    #
    #
    #
    #
    def call_pre_estimation_background_job
      clean_stats "parameters are being calculated in background"
    end
    #
    #
    #
    #
    # perform parameter estimation
    def call_estimation
      call_estimation_with_custom_params( self.dyna_model.params )
    end
    
    #
    #
    #
    #
    def call_estimation_with_custom_params(params)
      return unless !(self.measurement.nil?) || !(self.experiment.nil?) || !(self.dyna_model.estimation.nil?) || !(self.dyna_model.estimation == "")
      
      url = estimation_url( params )
      print "\n" + url.to_s + "\n\n"
      begin
        response = call_url(url)    
        
      rescue Timeout::Error => e
        clean_stats "timeout while calculating parameters, try again"
        return
      end
      result = JSON.parse( response.body.gsub(/(\n|\t)/,'') )
      
      self.proxy_params.each do |d_p|
        d_p.value = result[d_p.param.code] if !result[d_p.param.code].nil?
        d_p.save
        d_p
      end
      self.json = nil
      self.json_cache # call solver and calculate statistical data
    end
    #
    #
    #
    #
    def json_cache
      return self.json unless self.json.nil?
      return nil if self.call_solver.nil?
      self.statistical_data 
      self.json
    end
    #
    #
    #
    #
    def call_solver(time=nil)
      
      url = solver_url(time)  
      begin    
        response = call_url(url)
     rescue Timeout::Error
        self.notes = "timeout while simulating, try again"
        self.json = nil
        self.save
        return
      end
      temp_json = JSON.parse( response.body.gsub(/(\n|\t)/,'') )
      if temp_json["error"]
	print 'time: ' + time.to_s unless time.nil?
        if time.nil?
          call_solver(1)
	  print '\tcall_solver(1)'
          return self.json
        elsif (self.measurement.end - time < 0 )
          self.notes = "error while simulating data" + temp_json["error"].to_s
          self.json = nil
        else
          call_solver(time+1)
	  print '\tcall_solver(' + (time + 1).to_s +  ')'
          return self.json
        end
      else
        self.json = temp_json["result"].to_s
      end
      self.save
      self.json
    end
    #
    #
    #
    #  
    def original_data=(data)
      #@data = data
    end
    #
    #
    #
    #
    def convert_param(original_args)
      flag = false
      self.proxy_params.each { |param|
        temp = /#{param.code} = (?<value>[0-9]+[.]?[0-9]*)/.match(original_args)
        if temp
  #        print "---> " + temp.to_s + "\n"
          param.value = temp[:value]
          flag = true if param.save
        end
      }    
      self.call_solver if flag
      statistical_data if flag
    end
    
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
          list.first.custom_init
          list.first
        end
      }
     
    end
    
    def perform_clean_stats
        clean_stats(nil)
    end
    
  private
    # clean statistical information
    def clean_stats(note)
      self.rmse = nil
      self.bias = nil
      self.accuracy = nil
      self.notes = note
      self.proxy_params.each { |p| p.value = nil; p.save; }
      self.save
    end
    
    # get solver url with parameters
    def solver_url(time=nil)
      url_params = self.proxy_params.collect { |p|
        next if p.code == 'o'
        return nil if p.value.nil?      
        "#{p.param.code}=#{p.value.to_s}"
      }.compact.join('&')
      
      if self.measurement.nil?
        url = "#{self.dyna_model.solver}?#{url_params}&end=48"
      else
        if time.nil?
          url = "#{self.dyna_model.solver}?#{url_params}&#{self.measurement.end_title}=#{self.measurement.end.to_s}"
        else
          url = "#{self.dyna_model.solver}?#{url_params}&#{self.measurement.end_title}=#{(self.measurement.end-time).to_s}"
        end
      end
      url
    end
    
    # convert single parameter to url ready
    def param_to_url( code, top , bottom )
      CGI::escape("{\"name\"")   + ":" + CGI::escape("\"") + "#{code}"  + CGI::escape("\"") + "," +
      CGI::escape("\"bottom\"") + ":"  + "#{bottom}"    + "," +
      CGI::escape("\"top\"")    + ":"  + "#{top}" + CGI::escape("}")
    end
    
    def time_and_values
      
      # TODO make death phase optional
      if self.experiment.nil?
        x_array = self.measurement.x_array
        y_array = self.measurement.y_array
      else
        x_array = experiment.measurements.collect { |m|
          m.x_array.to_s
        }.join('];[')
        
        y_array = experiment.measurements.collect { |m|
          m.y_array.to_s
        }.join('];[')
     
      end
      
      return "time=[#{x_array}]&values=[#{y_array}]"          
   
    end
    
    #
    #
    #
    #
    def call_url(url)
      uri = URI(url)
      
      request = Net::HTTP::Get.new uri.request_uri
      res = Net::HTTP.start(uri.host, uri.port) {|http|
        timeout = 540
        http.open_timeout = timeout
        http.read_timeout = timeout
        http.request request
      }
    end
    
    # get solver url with parameters
    def estimation_url( params )
    
      url = "#{self.dyna_model.estimation}?#{time_and_values}"
      url += "&estimation=" + CGI::escape("{\"states\"") + ":["
      # URL parameters (that map against states in SBTOOLBOX2)
      url_states = params.collect { |p|
        next if p.output_only || p.initial_condition
        if p.top.nil? || p.bottom.nil?
          raise Exception.new(p.human_title.html_safe + " does not have top/bottom values")
        else
          param_to_url( p.code , p.top, p.bottom )
        end 
      }.compact.join(',') + "]"
      # URL initial conditions (that map against initial conditions in SBTOOLBOX2)
      url_ic = "," + CGI::escape("\"initial\"") + ":["
      url_ic += params.collect { |p|
        next unless p.initial_condition
        if p.top.nil? || p.bottom.nil?
          raise Exception.new(p.human_title.html_safe + " does not have top/bottom values")
        else
          param_to_url( p.code , p.top, p.bottom )
        end 
      }.compact.join(',') + ',' + param_to_url( "t" , "100" , "0" ) + "]" # adds time
  
      url += url_states + url_ic;
      url += CGI::escape("}")
      url
    end
  
end

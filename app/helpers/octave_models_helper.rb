module OctaveModelsHelper
  
  def hint_text(method_name,string)
    if @octave_model.send(method_name.to_sym).nil?
      "Please upload a #{string}."
    else
      "Overwrite current #{string}."
    end
  end
end

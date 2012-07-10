class CalculateJob < Struct.new(:calculate_ids, :custom_params )
  def perform
    proxy_dyna_models = ProxyDynaModel.find(calculate_ids)
    proxy_dyna_models.each do |pdm|
      pdm.call_estimation_with_custom_params( custom_params )
   end
  end
end


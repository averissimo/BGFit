# Load the rails application
require File.expand_path('../application', __FILE__)

require 'trim_blob_logging'
Mime::Type.register 'application/mfile', :m

# Initialize the rails application
BacteriaGrowth::Application.initialize!

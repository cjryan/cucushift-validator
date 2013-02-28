# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RailsApp::Application.initialize!

#Set Timezone
config.time_zone = 'EST'

# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# Load the application's environment variables from the env.rb file
load File.expand_path('env.rb', __dir__)

# Setup Capybara so that we can use the DSL for writing the tests
require 'capybara/rspec'

# We will use the selenium driver
Capybara.default_driver = :selenium_chrome

# We will not run our own server; we will connect to a remote server
Capybara.run_server = false

# Set the base URL for all our tests
Capybara.app_host = 'https://www.appacademy.io'

Capybara.default_max_wait_time = 10
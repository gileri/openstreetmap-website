Konacha.configure do |config|
  require 'capybara/poltergeist'
  config.spec_dir = "test/javascripts"
  config.driver   = :poltergeist
end if defined?(Konacha)

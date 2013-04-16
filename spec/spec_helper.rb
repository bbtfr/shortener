# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require 'shortener'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'shoulda/matchers/integrations/rspec'
require 'database_cleaner'

Rails.backtrace_cleaner.remove_silencers!
# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

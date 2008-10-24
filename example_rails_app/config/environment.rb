require File.join(File.dirname(__FILE__), 'boot')
require "rubygems"

Rails::Initializer.run do |config|
end

def in_memory_database?
  ENV["RAILS_ENV"] == "test" and
  ActiveRecord::Base.connection.class.to_s == "ActiveRecord::ConnectionAdapters::SQLite3Adapter" and
  Rails::Configuration.new.database_configuration['test']['database'] == ':memory:'
end

if in_memory_database?
  load "#{RAILS_ROOT}/db/schema.rb" # use db agnostic schema by default
  ActiveRecord::Migrator.up('db/migrate') # use migrations
end

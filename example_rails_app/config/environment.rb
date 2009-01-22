require File.join(File.dirname(__FILE__), 'boot')
require "rubygems"

Rails::Initializer.run do |config|
  if Rails.const_defined?(:VERSION) && Rails::VERSION::STRING >= '1.2.7'
    config.action_controller.session = {
      :session_key => '_rspec_rails_session',
      :secret      => '5716a6ba4342c76063b4a65dd7395e60b19c9d87f4bcc88af4322af953bf4e334e615f4810a62f1e13d241b4234c967ae8de7501282fd4234cfc5d49457b25cf'
    }
  end
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

# This fixes an issue with Ruby 1.8.7 & Rails 2.0.2
# See http://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg528878.html
unless '1.9'.respond_to?(:force_encoding)
  String.class_eval do
    begin
      remove_method :chars
    rescue NameError
      # OK
    end
  end
end

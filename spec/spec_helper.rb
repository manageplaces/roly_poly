require 'rubygems'
require 'bundler/setup'
require 'roly_poly'
require 'database_cleaner'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

load File.dirname(__FILE__) + "/support/adapters/active_record.rb"
load File.dirname(__FILE__) + "/support/data.rb"

require 'shoulda/matchers'
require 'shoulda/matchers/integrations/rspec'

def reset_config
  RolyPoly.configure do |config|
    config.user_class_name = 'User'
    config.role_class_name = 'Role'
    config.permission_class_name = 'Permission'
    config.role_exclusivity = :one_per_resource
    config.role_exclusivity_error = :raise
  end
end

def load_data
  reset_config
  RolyPoly.class_mappings[:role][:klass].create(name: 'admin')
  RolyPoly.class_mappings[:role][:klass].create(name: 'moderator')
  RolyPoly.class_mappings[:role][:klass].create(name: 'manager')
  RolyPoly.class_mappings[:role][:klass].create(name: 'superhero')
  RolyPoly.class_mappings[:role][:klass].create(name: 'god')
  RolyPoly.class_mappings[:role][:klass].create(name: 'teammember')

  Forum.create(name: 'forum 1')
  Forum.create(name: 'forum 2')
  Forum.create(name: 'forum 3')

  Group.create(name: 'group 1')
  Group.create(name: 'group 2')

  RolyPoly.class_mappings[:user][:klass].create(name: 'admin')
  RolyPoly.class_mappings[:user][:klass].create(name: 'moderator')
  RolyPoly.class_mappings[:user][:klass].create(name: 'manager')
end

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    load_data
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.after(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

end

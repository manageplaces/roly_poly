# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'roly_poly'
require 'database_cleaner'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

load File.dirname(__FILE__) + '/support/adapters/active_record.rb'
load File.dirname(__FILE__) + '/support/data.rb'

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
  Company.create(name: 'Company')

  RolyPoly.class_mappings[:role][:klass].create(name: 'admin')
  RolyPoly.class_mappings[:role][:klass].create(name: 'moderator')
  RolyPoly.class_mappings[:role][:klass].create(name: 'manager')
  RolyPoly.class_mappings[:role][:klass].create(name: 'superhero')
  RolyPoly.class_mappings[:role][:klass].create(name: 'supervillain')
  RolyPoly.class_mappings[:role][:klass].create(name: 'god')
  RolyPoly.class_mappings[:role][:klass].create(name: 'teammember')

  RolyPoly.class_mappings[:role][:klass].create(name: 'company_admin', resource: Company.first)
  RolyPoly.class_mappings[:role][:klass].create(name: 'company_moderator', resource: Company.first)
  RolyPoly.class_mappings[:role][:klass].create(name: 'company_manager', resource: Company.first)
  RolyPoly.class_mappings[:role][:klass].create(name: 'company_superhero', resource: Company.first)
  RolyPoly.class_mappings[:role][:klass].create(name: 'company_supervillain', resource: Company.first)
  RolyPoly.class_mappings[:role][:klass].create(name: 'company_god', resource: Company.first)
  RolyPoly.class_mappings[:role][:klass].create(name: 'company_teammember', resource: Company.first)

  RolyPoly.class_mappings[:permission][:klass].create(name: 'create_user')
  RolyPoly.class_mappings[:permission][:klass].create(name: 'update_user')
  RolyPoly.class_mappings[:permission][:klass].create(name: 'view_user')
  RolyPoly.class_mappings[:permission][:klass].create(name: 'user_permission_a')
  RolyPoly.class_mappings[:permission][:klass].create(name: 'user_permission_b')
  RolyPoly.class_mappings[:permission][:klass].create(name: 'user_permission_c')
  RolyPoly.class_mappings[:permission][:klass].create(name: 'user_permission_d')

  Forum.create(name: 'forum 1')
  Forum.create(name: 'forum 2')
  Forum.create(name: 'forum 3')

  Group.create(name: 'group 1')
  Group.create(name: 'group 2')

  RolyPoly.class_mappings[:user][:klass].create(name: 'admin')
  RolyPoly.class_mappings[:user][:klass].create(name: 'moderator')
  RolyPoly.class_mappings[:user][:klass].create(name: 'manager')
end

def provision_user(user, roles)
  roles.each do |role|
    if role.is_a? Array
      user.add_role *role
    else
      user.add_role role
    end
  end
  user
end

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = %i[should expect] }

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

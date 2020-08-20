require 'rubygems'
require 'bundler/setup'

require 'roly_poly'
require 'rails/all'
require_relative 'support/stream_helpers'
include StreamHelpers


ENV['ADAPTER'] ||= 'active_record'

if ENV['ADAPTER'] == 'active_record'
  load File.dirname(__FILE__) + '/support/adapters/active_record.rb'
  require 'active_record/railtie'
  establish_connection
else
  # TODO: Add support for Mongoid
end

module TestApp
  class Application < ::Rails::Application
    config.root = File.dirname(__FILE__)
  end
end


require 'ammeter/init'

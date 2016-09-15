module RolyPoly
  module Generators

    class RolyPolyGenerator < Rails::Generators::Base
      Rails::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      argument :role_class, type: :string, default: 'Role'
      argument :permission_class, type: :string, default: 'Permission'
      argument :user_class, type: :string, default: 'User'

      namespace :roly_poly
      # hook_for :orm, required: true
      hook_for(:orm, required: true) do |invoked|
        invoke invoked, [ role_class, permission_class, user_class ]
      end

      desc 'Generates the required models and migration files.'


      def configure_user_class
        invoke 'roly_poly:user', [user_class]
      end

      def create_initializer
        template 'initializer.rb', 'config/initializers/roly_poly.rb'
      end
    end

  end
end

require 'rails/generators/active_record'
require 'active_support/core_ext'

module ActiveRecord
  module Generators

    class RolyPolyGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      # argument :role_class, type: :string, default: 'Role', banner: 'Role'
      argument :permission_class, type: :string, default: 'Permission', banner: 'Permission'
      argument :user_class, type: :string, default: 'User', banner: 'User'

      def role_class
        name
      end


      # Creates the role model with the user
      # defined name
      def generate_role_model
        template 'role.rb', role_model_path
      end

      def generate_permission_model
        template 'permission.rb', permission_model_path
      end

      def generate_role_permission_model
        template 'role_permission.rb', role_permission_model_path
      end

      def generate_user_role_model
        template 'user_role.rb', user_role_model_path
      end

      def generate_user_permission_model
        template 'user_permission.rb', user_permission_model_path
      end

      def create_roly_poly_migrations
        migration_template 'role_migration.rb', "db/migrate/roly_poly_create_#{role_class.underscore.downcase.pluralize}.rb"
        migration_template 'permission_migration.rb', "db/migrate/roly_poly_create_#{permission_class.underscore.downcase.pluralize}.rb"
        migration_template 'role_permission_migration.rb', "db/migrate/roly_poly_create_#{role_permissions_association_name}.rb"
        migration_template 'user_roles_migration.rb', "db/migrate/roly_poly_create_#{user_class.underscore.downcase}_#{role_class.underscore.downcase.pluralize}.rb"
        migration_template 'user_permissions_migration.rb', "db/migrate/roly_poly_create_#{user_class.underscore}_#{permission_class.underscore.pluralize}.rb"
      end


      private

      # ################## #
      # MODEL PATH METHODS #
      # ################## #

      def role_model_path
        File.join('app', 'models', "#{role_class.underscore.downcase}.rb")
      end

      def permission_model_path
        File.join('app', 'models', "#{permission_class.underscore.downcase}.rb")
      end

      def role_permission_model_path
        File.join('app', 'models', "#{role_permissions_association_name.singularize}.rb")
      end

      def user_role_model_path
        File.join('app', 'models', "#{user_class.underscore.downcase}_#{role_class.underscore.downcase}.rb")
      end

      def user_permission_model_path
        File.join('app', 'models', "#{user_class.underscore.downcase}_#{permission_class.underscore.downcase}.rb")
      end

      # ################## #
      # CLASS NAME METHODS #
      # ################## #

      def permission_class_name
        permission_class.camelize
      end

      def role_permission_class_name
        "#{role_class.camelize}#{permission_class.camelize}"
      end

      def role_class_name
        role_class.camelize
      end

      def user_role_class_name
        "#{user_class.camelize}#{role_class.camelize}"
      end

      def user_permission_class_name
        "#{user_class.camelize}#{permission_class.camelize}"
      end

      # ############ #
      # ASSOCIATIONS #
      # ############ #

      def roles_association_name
        role_class.underscore.downcase.pluralize
      end

      def role_permissions_association_name
        "#{role_class.underscore.downcase.singularize}_#{permissions_association_name}"
      end

      def permissions_association_name
        permission_class.underscore.downcase.pluralize
      end

      def user_roles_association_name
        "#{user_class.underscore.downcase.singularize}_#{roles_association_name}"
      end

      def users_association_name
        user_class.underscore.pluralize
      end

      def user_permissions_association_name
        "#{user_class.underscore}_#{permissions_association_name}"
      end


      # ################## #
      # TABLE NAME METHODS #
      # ################## #

      def roles_table_name
        roles_association_name
      end

      def permissions_table_name
        permissions_association_name
      end

      def role_permissions_table_name
        role_permissions_association_name
      end

      def user_roles_table_name
        user_roles_association_name
      end

      def user_permissions_table_name
        user_permissions_association_name
      end

    end

  end
end

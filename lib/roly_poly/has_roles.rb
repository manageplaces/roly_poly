require 'active_support/concern'
require 'roly_poly/finders'
require 'roly_poly/grants'
require 'roly_poly/adapters/base'

#
# The HasRole module should be included by the
# user model of the application. This will provide
# relations, and helper methods for manipulating
# roles that a user has.
#
# This does not need to be included directly, and
# should not be included directly. All models will
# already have access to the function `has_role`
# which should be used. This will automatically
# include this module.
#
module RolyPoly
  module HasRoles
    extend ActiveSupport::Concern

    included do
      include Finders
      include Grants

      class_attribute :adapter

      has_many "#{RolyPoly.user_class_name.underscore}_privileges".to_sym
      has_many "#{RolyPoly.role_class_name.underscore.pluralize}".to_sym, through: "#{RolyPoly.user_class_name.underscore}_privileges".to_sym, source: :privilege, source_type: "#{RolyPoly.role_class_name}"
      has_many "#{RolyPoly.permission_class_name.underscore.pluralize}".to_sym, through: "#{RolyPoly.user_class_name.underscore}_privileges".to_sym, source: :privilege, source_type: "#{RolyPoly.permission_class_name}"

      # has_many "#{RolyPoly.user_class_name.underscore.downcase}_#{RolyPoly.role_class_name.underscore.downcase.pluralize}".to_sym
      # has_many "#{RolyPoly.role_class_name.underscore.downcase.pluralize}".to_sym, through: "#{RolyPoly.user_class_name.underscore.downcase}_#{RolyPoly.role_class_name.underscore.downcase.pluralize}".to_sym

      # has_many "#{RolyPoly.user_class_name.underscore.downcase}_#{RolyPoly.permission_class_name.underscore.downcase.pluralize}".to_sym
      # has_many "#{RolyPoly.permission_class_name.underscore.downcase.pluralize}".to_sym, through: "#{RolyPoly.user_class_name.underscore.downcase}_#{RolyPoly.permission_class_name.underscore.downcase.pluralize}".to_sym

      self.adapter = RolyPoly::Adapters::Base.create('role_adapter')
    end

  end
end

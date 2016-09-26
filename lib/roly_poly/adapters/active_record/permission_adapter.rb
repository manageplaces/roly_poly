require 'roly_poly/adapters/base'

module RolyPoly
  module Adapters
    class PermissionAdapter < PermissionAdapterBase

      def add_permission(role, name)
        permission = mappings[:permission][:klass].find_by_name(name)
        return false if permission.nil?

        mappings[:role_permission][:klass].where("#{mappings[:role][:relation_name]}_id" => role.id, "#{mappings[:permission][:relation_name]}_id" => permission.id).first_or_create.nil?
      end

      def remove_permission(role, name)
        permission = mappings[:permission][:klass].find_by_name(name)
        return true if permission.nil?

        mappings[:role_permission][:klass].where("#{mappings[:role][:relation_name]}_id" => role.id, "#{mappings[:permission][:relation_name]}_id" => permission.id).destroy_all
      end

      def has_permission?(role, name)
        permission = mappings[:permission][:klass].find_by_name(name)
        return false if permission.nil?

        mappings[:role_permission][:klass].where("#{mappings[:role][:relation_name]}_id" => role.id, "#{mappings[:permission][:relation_name]}_id" => permission.id).count > 0
      end

      private

      def mappings
        RolyPoly.class_mappings
      end

    end
  end
end

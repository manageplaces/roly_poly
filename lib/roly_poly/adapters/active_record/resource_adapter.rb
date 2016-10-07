require 'roly_poly/adapters/base'
require 'roly_poly/utils'

module RolyPoly
  module Adapters
    class ResourceAdapter < ResourceAdapterBase

      def resources_find_by_permission(klass, permission, user = nil)
        permission = Permission.find_by_name(permission) if permission.is_a?(String) || permission.is_a?(Symbol)
        return [] if permission.nil?

        unless permission.is_a?(mapping(:permission)[:klass])
          raise ArgumentError, 'Invalid argument type: only hashes, string and symbols are allowed'
        end

        permission_roles = permission.send(mapping(:role)[:plural_relation_name]).pluck(:id)
        where_values = [mapping(:permission)[:klass].name, permission.id]
        where_clause = "#{mapping(:user)[:relation_name]}_privileges.privilege_type = ? AND
                        #{mapping(:user)[:relation_name]}_privileges.privilege_id = ?"

        unless permission_roles.empty?
          where_clause = "((#{where_clause}) OR (#{mapping(:user)[:relation_name]}_privileges.privilege_type = ? AND
                                              #{mapping(:user)[:relation_name]}_privileges.privilege_id IN (?)))"
          where_values << mapping(:role)[:klass].name << permission_roles
        end

        puts "WHERE #{where_clause}, #{where_values}"
        resources = klass.joins("#{mapping(:user)[:relation_name]}_privileges".to_sym).where(where_clause, *where_values)

        unless user.nil?
          resources = resources.where("#{mapping(:user)[:relation_name]}_privileges".to_sym => {
            "#{mapping(:user)[:relation_name]}_id".to_sym => user.id
          })
        end

        resources
      end

      def resources_find_by_role(klass, role, user = nil)
        role = Role.find_by_name(role) if role.is_a?(String) || role.is_a?(Symbol)
        return [] if role.nil?

        unless role.is_a?(mapping(:role)[:klass])
          raise ArgumentError, 'Invalid argument type: only hashes, string and symbols are allowed'
        end

        resources = klass
                      .joins("#{mapping(:user)[:relation_name]}_privileges".to_sym)
                      .where("#{mapping(:user)[:relation_name]}_privileges".to_sym => {
                        privilege_type: mapping(:role)[:klass].name,
                        privilege_id: role.id
                      })

        unless user.nil?
          resources = resources.where("#{mapping(:user)[:relation_name]}_privileges".to_sym => {
            "#{mapping(:user)[:relation_name]}_id".to_sym => user.id
          })
        end

        resources
      end


      private

      def mapping(mapping)
        RolyPoly.class_mappings[mapping]
      end

    end
  end
end

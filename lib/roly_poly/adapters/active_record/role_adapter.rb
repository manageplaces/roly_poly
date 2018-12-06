require 'roly_poly/adapters/base'
require 'roly_poly/utils'

module RolyPoly
  module Adapters
    class RoleAdapter < RoleAdapterBase

      #
      # Adds a role record to a user.
      #
      def add(user, role_permission, resource = nil)
        opts = {
          mappings[:user][:relation_name] => user,
          privilege: role_permission
        }

        if resource.is_a?(Class)
          opts[:resource_type] = resource.to_s
          opts[:resource_id] = nil
        else
          opts[:resource] = resource
        end

        mappings[:user_privilege][:klass].create(opts)
      end



      #
      # Retrieves a role record by its name. Note that
      # role names are case sensitive. i.e. ADMIN
      # and admin are two different roles.
      #
      def find_role(role)
        conditions, values = role_lookup_condition(role)
        mappings[:role][:klass].where(conditions, *values).first
      end

      def find_permission(permission)
        conditions, values = permission_lookup_condition(permission)
        mappings[:permission][:klass].where(conditions, *values).first
      end

      def has_existing_privilege?(user, resource = nil, privilege = nil)
        scope = user.send(mappings[:user_privilege][:plural_relation_name])
                  .where(resource_where_conditions(resource))

        unless privilege.nil?
          scope = scope.where(privilege_type: privilege.class.name, privilege_id: privilege.id)
        end

        scope.count > 0
      end

      def remove_role(user, role, resource = nil)
        scope = user.send(mappings[:user_privilege][:plural_relation_name])
                .where(privilege_id: role.try(:id), privilege_type: mappings[:role][:klass].name)

        if resource.is_a?(Class)
          scope = scope.where(resource_type: resource.to_s)
        elsif resource
          scope = scope.where(resource_type: resource.class.name, resource_id: resource.id)
        end

        scope.destroy_all
      end

      #
      # When the role exclusivity is set to :one_per_user
      # or :one_per_resource, a user cannot have multiple
      # roles in general, or the same scope. This method
      # will replace the existing role with the specified
      # role
      #
      def replace_role(user, role, resource = nil)
        roles = user.send(mappings[:user_privilege][:plural_relation_name])
                    .where(privilege_type: mappings[:role][:klass].name)
                    .destroy_all

        self.add(user, role, resource == :any ? nil : resource)
      end

      #
      # Retrieves a list of all roles for a given
      # user and resource
      #
      def roles(user, resource = nil)
        scope = mappings[:role][:klass]
                .joins(mappings[:user_privilege][:plural_relation_name] =>
                  mappings[:user][:relation_name]
                )
                .where(mappings[:user][:plural_relation_name] => { id: user.id })

        unless resource == :any
          scope = scope.where(mappings[:user_privilege][:plural_relation_name] => resource_where_conditions(resource))
        end

        scope
          .distinct
          .all
      end


      def has_permission?(user, permission, resource = nil)
        conditions, values = build_query_scope([{ permission: permission, resource: resource }], :permission)
        scope = mappings[:permission][:klass]
                .joins(mappings[:role_permission][:plural_relation_name] => {
                  mappings[:role][:relation_name] => mappings[:user_privilege][:plural_relation_name]
                })
                .where(mappings[:user_privilege][:plural_relation_name] => { user_id: user.id })
                .where(conditions, *values)

        return true if scope.count > 0

        conditions, values = build_query_scope([{ permission: permission, resource: resource }], :permission)
        scope = mappings[:permission][:klass]
                .joins(mappings[:user_privilege][:plural_relation_name])
                .where(mappings[:user_privilege][:plural_relation_name] => { user_id: user.id })
                .where(conditions, *values)

        scope.count > 0
      end

      def where(relation, *args)
        conditions, values = build_query_scope(args)
        relation.where(conditions, *values)
      end

      def role_scope(relation, *args)
        conditions, values = build_query_scope(args)
        relation
          .joins(mappings[:role][:plural_relation_name])
          .joins(mappings[:user_privilege][:plural_relation_name])
          .where(conditions, *values)
          .distinct
      end

      def permission_scope(relation, *args)
        conditions, values = build_query_scope(args, :permission)
        role_permission_scope = mappings[:permission][:klass]
                                .joins(mappings[:role_permission][:plural_relation_name] => {
                                  mappings[:role][:relation_name] => mappings[:user_privilege][:plural_relation_name]
                                })
                                .where(conditions, *values)

        permission_scope = mappings[:permission][:klass]
                            .joins(mappings[:user_privilege][:plural_relation_name])
                            .where(conditions, *values)

        privilege_conditions = "(#{mappings[:user_privilege][:plural_relation_name]}.privilege_type = ? AND #{mappings[:user_privilege][:plural_relation_name]}.privilege_id IN (?)) OR
                      (#{mappings[:user_privilege][:plural_relation_name]}.privilege_type = ? AND #{mappings[:user_privilege][:plural_relation_name]}.privilege_id IN (?))"

        privilege_values = [mappings[:permission][:klass].name, permission_scope.pluck("#{mappings[:permission][:plural_relation_name]}.id"),
                  mappings[:role][:klass].name, role_permission_scope.pluck("#{mappings[:role][:plural_relation_name]}.id")]

        conditions = []
        values = []

        args.each do |arg|
          if arg.is_a?(Hash)
            c, b = query_conditions(privilege_conditions, privilege_values, arg[:resource])
          elsif arg.is_a?(String) || arg.is_a?(Symbol)
            c, b = query_conditions(conditions, values, nil)
          else
            raise ArgumentError, 'Invalid argument type: only hashes, string and symbols are allowed'
          end

          conditions << c
          values += b
        end

        conditions = conditions.join(' OR ')
        testing = relation
          .joins(mappings[:user_privilege][:plural_relation_name])
          .where(conditions, *values)
          .distinct

        testing
      end


      private

      def query_scope(klass)
        klass.where(nil)
      end

      def mappings
        RolyPoly.class_mappings
      end

      def build_query_scope(args, type = :role)
        conditions = []
        values = []
        args.each do |arg|
          if arg.is_a?(Hash)
            c, b = build_query(arg[type], arg[:resource], type)
          elsif arg.is_a?(String) || arg.is_a?(Symbol)
            c, b = build_query(arg.to_s, nil, type)
          else
            raise ArgumentError, 'Invalid argument type: only hashes, string and symbols are allowed'
          end

          conditions << c
          values += b
        end

        conditions = conditions.join('OR')
        [ conditions, values ]
      end

      def build_query(role_or_permission, resource = nil, type = :role)
        if type == :role
          build_role_query(role_or_permission, resource, type)
        else
          build_permission_query(role_or_permission, resource, type)
        end
      end

      def build_role_query(role, resource, type)
        return role_lookup_condition(role) if resource == :any
        conditions, values = query_conditions(*role_lookup_condition(role), resource, type)
      end

      def build_permission_query(permission, resource, type)
        return permission_lookup_condition(permission) if resource == :any
        conditions, values = query_conditions(*permission_lookup_condition(permission), resource, type)
      end

      def role_lookup_condition(role)
        roles_table = mappings[:role][:plural_relation_name]

        if role.is_a?(Symbol) || role.is_a?(String)
          [ "(#{roles_table}.name = ? AND #{roles_table}.resource_type IS NULL AND #{roles_table}.resource_id IS NULL)", [ role ] ]
        elsif role.is_a?(Hash)
          [ "(#{roles_table}.name = ? AND #{roles_table}.resource_type = ? AND #{roles_table}.resource_id = ?)", [ role[:name], role[:resource].class.name, role[:resource].id ]]
        elsif role.is_a?(mappings[:role][:klass])
          [ "(#{roles_table}.id = ?)", [ role.id ]]
        else
          raise ArgumentError, 'Invalid argument type: only hashes, string, symbols, and role instances are allowed'
        end
      end

      def permission_lookup_condition(permission)
        permissions_table = mappings[:permission][:plural_relation_name]

        if permission.is_a?(Symbol) || permission.is_a?(String)
          ["(#{permissions_table}.name = ?)", [ permission ]]
        elsif permission.is_a?(mappings[:permission][:klass])
          ["(#{permissions_table}.id = ?)", [ permission.id ]]
        else
          raise ArgumentError, 'Invalid argument type: only string, symbols, and permission instances are allowed'
        end
      end

      def query_conditions(conditions, values, resource, type = :role)
        join_table = mappings[:user_privilege][:plural_relation_name]
        condition_values = values

        query = "(#{conditions} AND (#{join_table}.resource_type IS NULL) AND (#{join_table}.resource_id IS NULL))"

        if resource
          query += " OR (#{conditions} AND (#{join_table}.resource_type = ?) AND (#{join_table}.resource_id IS NULL))"
          values += condition_values
          values << (resource.is_a?(Class) ? resource.to_s : resource.class.name)

          if !resource.is_a?(Class)
            query += " OR (#{conditions} AND (#{join_table}.resource_type = ?) AND (#{join_table}.resource_id = ?))"
            values += condition_values
            values << resource.class.name << resource.id
          end

          query = "(#{query})"
        end

        [query, values]
      end

      def resource_where_conditions(resource = nil)
        if resource.is_a?(Class)
          { resource_type: resource.to_s, resource_id: nil }
        elsif resource.nil?
          { resource_id: nil, resource_type: nil }
        elsif resource != :any
          { resource_type: resource.class.name, resource_id: resource.id }
        end
      end

    end
  end
end

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
          mappings[:user][:relation_name] => user
        }

        if role_permission.is_a?(mappings[:role][:klass])
          opts[mappings[:role][:relation_name]] = role_permission
        elsif role_permission.is_a?(mappings[:permission][:klass])
          opts[mappings[:permission][:relation_name]] = role_permission
        end

        if resource.is_a?(Class)
          opts[:resource_type] = resource.to_s
          opts[:resource_id] = nil
        else
          opts[:resource] = resource
        end

        if role_permission.is_a?(mappings[:role][:klass])
          mappings[:user_role][:klass].create(opts)
        elsif role_permission.is_a?(mappings[:permission][:klass])
          mappings[:user_permission][:klass].create(opts)
        end
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

      def has_existing_role?(user, resource = nil, role = nil)
        scope = user.send(mappings[:user_role][:plural_relation_name])

        if resource.is_a?(Class)
          scope = scope.where(resource_type: resource.to_s, resource_id: nil)
        elsif resource.nil?
          scope = scope.where(resource_id: nil, resource_type: nil)
        elsif resource != :any
          scope = scope.where(resource_type: resource.class.name, resource_id: resource.id)
        end

        unless role.nil?
          scope = scope.where("#{mappings[:role][:relation_name]}_id".to_sym => role.id)
        end

        scope.count > 0
      end

      def has_existing_permission?(user, resource = nil, permission = nil)
        scope = user.send(mappings[:user_permission][:plural_relation_name])

        if resource.is_a?(Class)
          scope = scope.where(resource_type: resource.to_s, resource_id: nil)
        elsif resource.nil?
          scope = scope.where(resource_type: nil, resource_id: nil)
        elsif resource != :any
          scope = scope.where(resource_type: resource.class.name, resource_id: resource.id)
        end

        unless permission.nil?
          scope = scope.where("#{mappings[:permission][:relation_name]}_id".to_sym => permission.id)
        end

        scope.count > 0
      end

      def remove_role(user, role, resource = nil)
        scope = mappings[:user_role][:klass].
                  where("#{mappings[:user][:relation_name]}_id" => user.id).
                  where("#{mappings[:role][:relation_name]}_id" => role.try(:id))

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
        roles = user.send(mappings[:user_role][:plural_relation_name])
        roles.destroy_all

        self.add(user, role, resource == :any ? nil : resource)
      end

      #
      # Retrieves a list of all roles for a given
      # user and resource
      #
      def roles(user, resource = nil)
        scope = mappings[:role][:klass].
                  joins(mappings[:user_role][:plural_relation_name] =>
                    mappings[:user][:relation_name]
                  ).
                  where(mappings[:user][:plural_relation_name] => { id: user.id })

        if resource.is_a?(Class)
          scope = scope.where(mappings[:user_role][:plural_relation_name] => { resource_type: resource.to_s })
        elsif resource && resource != :any
          scope = scope.where(mappings[:user_role][:plural_relation_name] => { resource_type: resource.class.name, resource_id: resource.id })
        end

        scope = scope.uniq
        scope.all
      end

      def has_permission?(user, permission, resource = nil)
        conditions, values = build_query_scope([{ name: permission, resource: resource }], :role_permission)
        scope = mappings[:permission][:klass].
                  joins(mappings[:role_permission][:plural_relation_name] => {
                    mappings[:role][:relation_name] => mappings[:user_role][:plural_relation_name]
                  }).
                  where(mappings[:user_role][:plural_relation_name] => { user_id: user.id }).
                  where(conditions, *values)

        return true if scope.count > 0

        conditions, values = build_query_scope([{ name: permission, resource: resource }], :user_permission)
        scope = mappings[:permission][:klass].
                  joins(mappings[:user_permission][:plural_relation_name] => {
                    mappings[:permission][:relation_name] => mappings[:user_permission][:plural_relation_name]
                  }).
                  where(mappings[:user_permission][:plural_relation_name] => { user_id: user.id }).
                  where(conditions, *values)

        scope.count > 0
      end

      def where(relation, *args)
        conditions, values = build_query_scope(args)
        relation.where(conditions, *values)
      end

      def role_scope(relation, *args)
        where(relation.joins(mappings[:role][:plural_relation_name]), *args)
      end


      def with_role(klass, role_name, resource = nil)
        query_scope(klass).
          joins(Utils.roles_table.to_sym).
          where(Utils.roles_table.to_sym => { name: role_name, resource: resource })
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
            c, b = build_query(arg[type == :role ? :role : :name], arg[:resource], type)
          elsif arg.is_a?(String) || arg.is_a?(Symbol)
            c, b = build_role_query(arg.to_s, nil, type)
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
        join_table = query_join_table(type)
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

      def query_join_table(type = :role)
        if type == :user_permission
          mappings[:user_permission][:plural_relation_name]
        else
          mappings[:user_role][:plural_relation_name]
        end
      end

      # def test
      #   name_table = mappings[type][:plural_relation_name]
      #   user_role_table = mappings[:user_role][:plural_relation_name]
      #
      #   return [ "#{name_table}.name = ?", [name] ] if resource == :any
      #
      #   query = "((#{name_table}.name = ?) AND (#{user_role_table}.resource_type IS NULL) AND (#{user_role_table}.resource_id IS NULL))"
      #   values = [ name ]
      #
      #   if resource
      #     query.insert(0, '(')
      #     query += " OR ((#{name_table}.name = ?) AND (#{user_role_table}.resource_type = ?) AND (#{user_role_table}.resource_id IS NULL))"
      #     values << name << ( resource.is_a?(Class) ? resource.to_s : resource.class.name )
      #
      #     if !resource.is_a?(Class)
      #       query += " OR ((#{name_table}.name = ?) AND (#{user_role_table}.resource_type = ?) AND (#{user_role_table}.resource_id = ?))"
      #       values << name << resource.class.name << resource.id
      #     end
      #
      #     query += ')'
      #   end
      #
      #   [query, values]
      # end

    end
  end
end

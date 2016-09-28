require 'logger'

module RolyPoly
  module Utils

    class RoleDefinitionError < StandardError
    end


    def self.logger
      if defined?(Rails)
        Rails.logger
      else
        Logger.new(STDOUT)
      end
    end

    #
    # Converts an array of roles or permissions
    # into a common format that is used throughout
    # RolyPoly. Each item in the array can be in
    # one of 4 formats:
    #
    # - "role" - A string
    # - :role  - A symbol
    # - [:role, resource] - An array containing the role/permission name, and the resource it it scoped to
    # - { role: :role, resource: resource } - A hash containing the role/permission name, and the resource it is scoped to
    #
    # The result of this method is an array of
    # role name, resource pairs. Below is an example.
    #
    #
    #     parse_roles([ :admin, :user, { role: :admin, resource: company1 }, { role: :user, resource: company2 } ])
    #     => [ ['admin', nil], ['user', nil], ['admin', company1], ['user', company2] ]
    #
    def self.parse_roles(*roles)
      result = []
      roles.each do |role|
        if role.is_a?(Symbol) || role.is_a?(String)
          result << [role.to_s, nil]
        elsif role.is_a?(Array)
          if role.count != 2
            raise RoleDefinitionError.new 'Invalid role supplied. Array must contain exactly 2 values - role and resource'
          end
          result << role
        elsif role.is_a?(Hash)
          indif = role.with_indifferent_access
          result << [indif[:role].to_s, indif[:resource]]
        else
          raise RoleDefinitionError.new 'Invalid role supplied. Expected Symbol, String, Array or Hash'
        end
      end

      result
    end

    def self.roles_table
      RolyPoly.role_class_name.constantize.table_name
    end

  end
end

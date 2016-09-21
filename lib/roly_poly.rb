require 'roly_poly/version'
require 'roly_poly/configuration'
require 'roly_poly/has_roles'
require 'roly_poly/role_resource'

module RolyPoly
  extend Configuration

  @@role_resource_types = []

  def has_roles(opts = {})
    include HasRoles
  end

  def role_resource
    include RoleResource
    @@role_resource_types << self.name
  end

  def self.role_resource_types
    @@role_resource_types
  end

end

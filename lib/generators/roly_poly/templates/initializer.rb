RolyPoly.configure do |config|

  # Specify the name of the role class. The table name will be
  # inferred from this. By default this will be 'Role'. Please
  # note that this will also affect the join tables and relations
  # between models, so please ensure that this option matches
  # the option use when generating the installation.

  <% if role_class.camelize == 'Role' %>
    # config.role_class_name = '<%= role_class.camelize.to_s %>'
  <% else %>
    config.role_class_name = '<%= role_class.camelize.to_s %>'
  <% end %>


  # Specify the name of the user class. The table name will be
  # inferred from this. By default this will be 'User'

  <% if user_class.camelize == 'User' %>
    # config.user_class_name = '<%= user_class.camelize.to_s %>'
  <% else %>
    config.user_class_name = '<%= user_class.camelize.to_s %>'
  <% end %>

  # Specify the name of the permission class. The table name will
  # be inferred from this. By default this will be 'Permission'

  <% if permission_class.camelize == 'Permission' %>
    # config.permission_class_name = '<%= permission_class.camelize.to_s %>'
  <% else %>
    config.permission_class_name = '<%= permission_class.camelize.to_s %>'
  <% end %>


  # Specifies how many roles a user can be assigned to. This can
  # be set to one of three options:
  #
  # - :one_per_user
  # - :one_per_resource
  # - :unrestricted
  #
  # :one_per_user
  # - This will ensure that a user can only ever be assigned
  #   one role, regardless of whether this is scoped to a resource.
  #
  # :one_per_resource
  # - The default option. This will ensure that a user can be
  #   assigned more then one role, but only one role per resource.
  #   For example, a use can be assigne RoleA and RoleB for
  #   CompanyA and CompanyB respectively, but they cannot be
  #   assigned RoleA and RoleB for just CompanyA.
  #
  # :unrestricted
  # - This imposes no restrictions on the roles that a user can
  #   be assigned to. The only exception is the assignment of the
  #   same role and same resource multiple times. RolyPoly will
  #   simply ignore this and make no changes
  #
  # config.role_exclusivity = :one_per_resource

  # Specifies what to do if the `role_exclusivity` option is
  # violated. This can be set to one of three options.
  #
  # - :raise
  # - :replace
  # - :ignore
  #
  # :raise
  # - If a role already exists, then RolyPoly will raise an
  #   exception.
  #
  # :replace
  # - If a role already exists, then it will be replaced with
  #   the new role.
  #
  # :ignore
  # - If a role already exists, then nothing will be done.
  #
  # config.role_exclusivity_error = :raise

end

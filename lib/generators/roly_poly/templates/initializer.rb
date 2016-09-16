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

end

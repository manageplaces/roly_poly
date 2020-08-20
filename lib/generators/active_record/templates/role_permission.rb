class <%= role_permission_class_name %> < ActiveRecord::Base

  belongs_to :<%= role_class.underscore.downcase %>
  belongs_to :<%= permission_class.underscore.downcase %>

  validates :<%= role_class.underscore.downcase %>, :<%= permission_class.underscore.downcase %>, presence: true
  validates :<%= role_class.underscore.downcase %>_id, uniqueness: { scope: :<%= permission_class.underscore.downcase %>_id }

end

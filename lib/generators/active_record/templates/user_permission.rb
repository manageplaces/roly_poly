class <%= user_permission_class_name %> < ActiveRecord::Base

  belongs_to :<%= user_class.underscore.downcase %>
  belongs_to :<%= permission_class.underscore.downcase %>
  belongs_to :resource, polymorphic: true

  validates :resource_type, inclusion: { in: RolyPoly.role_resource_types, allow_nil: true }
  validates :<%= user_class.underscore.downcase %>, :<%= permission_class.underscore.downcase %>, presence: true
  validates :<%= user_class.underscore.downcase %>_id, uniqueness: { scope: [:<%= permission_class.underscore.downcase %>_id, :resource_type, :resource_id] }
end

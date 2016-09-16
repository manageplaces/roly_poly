class <%= user_role_class_name %> < ActiveRecord::Base

  belongs_to :<%= user_class.underscore.downcase %>
  belongs_to :<%= role_class.underscore.downcase %>
  belongs_to :resource, polymorphic: true

  validates :resource_type, inclusion: { in: RolyPoly.role_resource_types }
  validates [:<%= user_class.underscore.downcase %>, :<%= role_class.underscore.downcase %>], presence: true
  validates :<%= user_class.underscore.downcase %>_id, uniqueness: { scope: [:<%= role_class.underscore.downcase %>_id, :resource_type, :resource_id] }
end

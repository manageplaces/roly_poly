class <%= user_privilege_class_name %> < ActiveRecord::Base

  belongs_to :<%= user_class.underscore.downcase %>
  belongs_to :privilege, polymorphic: true
  belongs_to :resource, polymorphic: true

  validates :resource_type, inclusion: { in: RolyPoly.role_resource_types, allow_nil: true }
  validates :privilege_type, inclusion: { in: <%= "[ #{role_class}, #{permission_class} ]" %>}

  validates :<%= user_class.underscore %>, :privilege, presence: true
  validates :<%= user_class.underscore %>_id, uniqueness: { scope: [:privilege_type, :privilege_id, :resource_type, :resource_id] }
end

class <%= role_class_name %> < ActiveRecord::Base

  has_many :<%= role_permissions_association_name %>
  has_many :<%= permissions_association_name %>, through: :<%= role_permissions_association_name %>

  belongs_to :resource, polymorphic: true

  validates :resource_type, inclusion: { in: RolyPoly.role_resource_types }
  validates :name, presence: true
  validates :name, uniqueness: { scope: [:resource_type, :resource_id] }

end

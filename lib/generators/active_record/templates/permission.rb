class <%= permission_class_name %> < ActiveRecord::Base

  has_many :<%= role_permissions_association_name %>
  has_many :<%= roles_association_name %>, through: :<%= role_permissions_association_name %>

  validates :name, presence: true
  validates :name, uniqueness: true
end

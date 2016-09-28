class RolyPolyCreate<%= user_privilege_class_name.pluralize %> < ActiveRecord::Migration

  def change

    create_table(:<%= user_privileges_table_name %>) do |t|
      t.references :<%= user_class.underscore.downcase %>, null: false
      t.references :privilege, null: false, polymorphic: true
      t.references :resource, polymorphic: true
    end

    add_index :<%= user_privileges_table_name %>, :<%= "#{user_class.underscore.downcase}_id" %>
    add_index :<%= user_privileges_table_name %>, [:privilege_type, :privilege_id]
    add_index :<%= user_privileges_table_name %>, [:resource_type, :resource_id]
    add_index :<%= user_privileges_table_name %>, [:<%= "#{user_class.underscore.downcase}_id" %>, :privilege_type, :privilege_id, :resource_type, :resource_id], unique: true, name: 'user_privilege_unique_idx'

  end

end

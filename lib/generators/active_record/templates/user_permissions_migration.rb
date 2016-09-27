class RolyPolyCreate<%= user_permission_class_name.pluralize %> < ActiveRecord::Migration

  def change

    create_table(:<%= user_permissions_table_name %>) do |t|
      t.references :<%= permissions_table_name.singularize %>, null: false
      t.references :<%= user_class.underscore.downcase %>, null: false
      t.references :resource, polymorphic: true
    end

    add_index :<%= user_permissions_table_name %>, :<%= "#{user_class.underscore.downcase}_id" %>
    add_index :<%= user_permissions_table_name %>, :<%= "#{permissions_table_name.singularize}_id" %>
    add_index :<%= user_permissions_table_name %>, [:resource_type, :resource_id]
    add_index :<%= user_permissions_table_name %>, [:<%= "#{user_class.underscore.downcase}}_id" %>, :<%= "#{permissions_table_name.singularize}_id" %>, :resource_type, :resource_id], unique: true

  end

end

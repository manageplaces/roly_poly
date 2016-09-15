class RolyPolyCreate<%= user_role_class_name.pluralize %> < ActiveRecord::Migration

  def change

    create_table(:<%= user_roles_table_name %>) do |t|
      t.references :<%= user_class.underscore.downcase %>, null: false
      t.references :<%= roles_table_name.singularize %>, null: false
      t.references :resource, polymorphic: true
    end

    add_index :<%= user_roles_table_name %>, :<%= "#{user_class.underscore.downcase}_id" %>
    add_index :<%= user_roles_table_name %>, :<%= "#{roles_table_name.singularize}_id" %>
    add_index :<%= user_roles_table_name %>, [:resource_type, :resource_id]
    add_index :<%= user_roles_table_name %>, [:<%= "#{user_class.underscore.downcase}_id" %>, :<%= "#{roles_table_name.singularize}_id" %>, :resource_type, :resource_id], unique: true, name: 'user_role_unique_idx'

  end

end

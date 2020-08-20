class RolyPolyCreate<%= role_permission_class_name.pluralize %> < ActiveRecord::Migration

  def change

    create_table(:<%= role_permissions_table_name %>) do |t|
      t.references :<%= roles_table_name.singularize %>, null: false
      t.references :<%= permissions_table_name.singularize %>, null: false
    end

    add_index :<%= role_permissions_table_name %>, :<%= "#{roles_table_name.singularize}_id" %>
    add_index :<%= role_permissions_table_name %>, :<%= "#{permissions_table_name.singularize}_id" %>
    add_index :<%= role_permissions_table_name %>, [:<%= "#{roles_table_name.singularize}_id" %>, :<%= "#{permissions_table_name.singularize}_id" %>], unique: true

  end

end

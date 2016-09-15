class RolyPolyCreate<%= role_class_name.pluralize %> < ActiveRecord::Migration

  def change

    create_table(:<%= roles_table_name %>) do |t|
      t.string :name, null: false
      t.string :description
      t.references :resource, polymorphic: true

      t.timestamps
    end

    add_index :<%= roles_table_name %>, [:name, :resource_id, :resource_type], unique: true, name: 'role_name_id'

  end

end

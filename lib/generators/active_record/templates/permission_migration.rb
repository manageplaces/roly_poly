class RolyPolyCreate<%= permission_class_name.pluralize %> < ActiveRecord::Migration

  def change

    create_table(:<%= permissions_table_name %>) do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps
    end

    add_index :<%= permissions_table_name %>, :name, unique: true

  end

end

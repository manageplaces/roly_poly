ActiveRecord::Schema.define do

  self.verbose = false

  [ :users, :resources, :forums, :groups, :companies ].each do |table|
    create_table(table) do |t|
      t.string :name
    end
  end

  [ :roles ].each do |table|
    create_table(table) do |t|
      t.string :name
      t.references :resource, polymorphic: true
    end
  end

  [ :permissions ].each do |table|
    create_table(table) do |t|
      t.string :name
    end
  end

  [ :role_permissions ].each do |table|
    create_table(table) do |t|
      t.references(:role)
      t.references(:permission)
    end
  end

  [ :user_privileges ].each do |table|
    create_table(table) do |t|
      t.references :user
      t.references :privilege, polymorphic: true
      t.references :resource, polymorphic: true
    end
  end

end

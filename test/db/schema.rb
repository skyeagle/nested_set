ActiveRecord::Schema.define(:version => 0) do

  create_table :categories, :force => true, :id => false do |t|
    t.primary_key :not_default_id_name
    t.column :name, :string
    t.column :parent_id, :integer
    t.column :lft, :integer
    t.column :rgt, :integer
    t.column :organization_id, :integer
    t.column :depth, :integer
  end

  create_table :departments, :force => true do |t|
    t.column :name, :string
  end

  create_table :notes, :force => true do |t|
    t.column :body, :text
    t.column :parent_id, :integer
    t.column :lft, :integer
    t.column :rgt, :integer
    t.column :notable_id, :integer
    t.column :notable_type, :string
  end

  create_table :renamed_columns, :force => true do |t|
    t.column :name, :string
    t.column :mother_id, :integer
    t.column :red, :integer
    t.column :black, :integer
    t.column :level, :integer
  end
end

if $0 == __FILE__

  plugin_test_dir = File.dirname(__FILE__)

  $:.unshift(plugin_test_dir + '/../lib')

  require 'rails/all'
  require 'nested_set'
  require 'bench_press'

  CollectiveIdea::Acts::NestedSet::Railtie.extend_active_record!
  #ActiveRecord::Base.logger = Logger.new(plugin_test_dir + "/debug.log")
  ActiveRecord::Base.configurations = YAML::load(IO.read(plugin_test_dir + "/db/database.yml"))
  ActiveRecord::Base.establish_connection(ENV["DB"] || "sqlite3mem")
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Schema.define(:version => 0) do
    create_table :categories, :force => true do |t|
      t.column :name, :string
      t.column :parent_id, :integer
      t.column :lft, :integer
      t.column :rgt, :integer
    end
  end

  class Category < ActiveRecord::Base
    acts_as_nested_set
  end

  Category.delete_all
  Category.create(:name => "Root Node 1")
  Category.create(:name => "Root Node 2")
  50.times do |i|
    node = Category.create(:name => "Node #{i}")
    set = Category.roots.map{|root| root.self_and_descendants}.flatten
    random_node = set[rand(set.size-1)]
    node.move_to_child_of(random_node)
  end

  include CollectiveIdea::Acts::NestedSet::Helper
  extend BenchPress

  reps 100

  measure "nested_set_options" do
    nested_set_options(Category){|i, level| "#{'-' * level} #{i.name}" }
  end

  measure "sorted_nested_set_options" do
    sorted_nested_set_options(Category, lambda{|x| x.name }){|i, level| "#{'-' * level} #{i.name}" }
  end

end

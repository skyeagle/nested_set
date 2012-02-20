class Category < ActiveRecord::Base
  self.primary_key = 'not_default_id_name'
  acts_as_nested_set

  def to_s
    name
  end

  def recurse(&block)
    block.call self, lambda{
      self.children.each do |child|
        child.recurse(&block)
      end
    }
  end

end

class Category_NoToArray < Category
  def to_a
    raise 'to_a called'
  end
end

class Category_DefaultScope < Category
  default_scope order('categories.not_default_id_name ASC')
end

class Category_WithCustomDestroy < ActiveRecord::Base
  self.table_name = 'categories'
  self.primary_key = 'not_default_id_name'
  acts_as_nested_set

  private :destroy
  def custom_destroy
    destroy
  end
end

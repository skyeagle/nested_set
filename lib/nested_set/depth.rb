# encoding: utf-8
module CollectiveIdea #:nodoc:
  module Acts #:nodoc:
    module NestedSet #:nodoc:
      module Depth
        # Model scope conditions
        def scope_condition(table_name=nil)
          table_name ||= self.class.quoted_table_name

          scope_string = Array(acts_as_nested_set_options[:scope]).map do |c|
            "#{table_name}.#{connection.quote_column_name(c)} = #{self.send(c)}"
          end.join(" AND ")

          scope_string.blank? ? "1 = 1" : scope_string
        end


        def has_depth_column?
          respond_to?(depth_column_name)
        end

        # Update cached_level attribute
        def update_depth
          send :"#{depth_column_name}=", level
          if depth_changed?
            self.self_and_descendants.
              update_all(["#{self.class.quoted_depth_column_name} = COALESCE(#{self.class.quoted_depth_column_name}, 0) + ?",
                depth_change[1] - depth_change[0].to_i])
          end
        end

        # Update cached_level attribute for all record tree
        def update_all_depth
          if has_depth_column?
            self.class.connection.execute("UPDATE #{self.class.quoted_table_name} a SET a.depth = \
                (SELECT count(*) - 1 FROM (SELECT * FROM #{self.class.quoted_table_name} WHERE #{scope_condition}) AS b \
              	WHERE #{scope_condition('a')} AND \
              	(a.#{quoted_left_column_name} BETWEEN b.#{quoted_left_column_name} AND b.#{quoted_right_column_name}))
              	WHERE #{scope_condition('a')}
              ")
          end
        end
      end
    end
  end
end

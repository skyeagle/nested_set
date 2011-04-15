# encoding: utf-8
module CollectiveIdea #:nodoc:
  module Acts #:nodoc:
    module NestedSet #:nodoc:
      # This module provides some helpers for the model classes using acts_as_nested_set.
      # It is included by default in all views.
      #
      module Helper
        # Returns options for select.
        # You can exclude some items from the tree.
        # You can pass a block receiving an item and returning the string displayed in the select.
        #
        # == Params
        #  * +class_or_items+ - Class name or top level items
        #  * +mover+ - The item that is being move, used to exclude impossible moves
        #  * +options+ - hash of additional options
        #  * +&block+ - a block that will be used to display: { |item| ... item.name }
        #
        # == Options
        #  * +include_root+ - Include root object(s) in output. Default: true
        #
        # == Usage
        #
        #   <%= f.select :parent_id, nested_set_options(Category, @category) {|i, level|
        #       "#{'–' * level} #{i.name}"
        #     }) %>
        #
        def nested_set_options(class_or_items, mover = nil, options = {})
          items = case
          when class_or_items.is_a?(Class)
            class_or_items.roots
          when class_or_items.is_a?(Array)
            class_or_items
          else
            [class_or_items]
          end

          options.assert_valid_keys :include_root
          options.reverse_merge! :include_root => true

          result = []
          items.each do |item|
            objects = options[:include_root] ? item.self_and_descendants : item.descendants
            objects.each_with_level do |i, level|
              if mover.nil? || mover.new_record? || mover.move_possible?(i)
                result.push([yield(i, level), i.id])
              end
            end
          end
          result
        end

        # Returns options for select.
        # You can sort node's child by any method
        # You can exclude some items from the tree.
        # You can pass a block receiving an item and returning the string displayed in the select.
        #
        # == Params
        #  * +class_or_item+ - Class name or top level times
        #  * +sort_proc+ sorting proc for node's child, ex. lambda{|x| x.name}
        #  * +mover+ - The item that is being move, used to exlude impossible moves
        #  * +level+ - start level, :default => 0
        #  * +&block+ - a block that will be used to display: { |itemi, level| "#{'–' * level} #{i.name}" }
        # == Usage
        #
        #   <%= f.select :parent_id, sorted_nested_set_options(Category, lambda(&:name)) {|i, level|
        #       "#{'–' * level} #{i.name}"
        #     }) %>
        #
        #   OR
        #
        #   sort_method = lambda{|x| x.name.mb_chars.downcase }
        #
        #   <%= f.select :parent_id, nested_set_options(Category, sort_method) {|i, level|
        #       "#{'–' * level} #{i.name}"
        #     }) %>
        #
        def sorted_nested_set_options(class_or_item, sort_proc, mover = nil, level = 0)
          hash = if class_or_item.is_a?(Class)
                   class_or_item
                 else
                   class_or_item.self_and_descendants
                 end.arrange
          build_node(hash, sort_proc, mover, level){|x, lvl| yield(x, lvl)}
        end

        def build_node(hash, sort_proc, mover = nil, level = nil)
          result = []
          hash.keys.sort_by(&sort_proc).each do |node|
            if mover.nil? || mover.new_record? || mover.move_possible?(node)
              result.push([yield(node, level.to_i), node.id])
              result.push(*build_node(hash[node], sort_proc, mover, level.to_i + 1){|x, lvl| yield(x, lvl)})
            end
          end if hash.present?
          result
        end

        # Recursively render arranged nodes hash
        #
        # == Params
        #  * +hash+ - Hash or arranged nodes, i.e. Category.arranged
        #  * +options+ - HTML options for root ul node.
        #    Given options with ex. :sort => lambda{|x| x.name}
        #    you allow node sorting by analogy with sorted_nested_set_options helper method
        #  * +&block+ - A block that will be used to display node
        #
        # == Usage
        #
        #   arranged_nodes = Category.arranged
        #
        #   <%= render_tree arranged_nodes do |node, child| %>
        #     <li><%= node.name %></li>
        #     <%= child %>
        #   <% end %>
        #
        def render_tree(hash,tag = :ul , options = {}, &block)
          sort_proc = options.delete :sort
          content_tag tag, options do
            hash.keys.sort_by(&sort_proc).each do |node|
              block.call node, render_tree(hash[node], tag ,:sort => sort_proc, &block)
            end
          end if hash.present?
        end

      end
    end
  end
end

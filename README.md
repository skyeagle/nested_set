[![Build Status](https://secure.travis-ci.org/skyeagle/nested_set.png)](http://travis-ci.org/skyeagle/nested_set)

# NestedSet

Nested Set is an implementation of the nested set pattern for ActiveRecord models. It is replacement for acts_as_nested_set and BetterNestedSet, but awesomer. It supports Rails 3.0 and later.

## See, it's Rails 3 only.

## Installation

The plugin is available as a gem:

    gem 'nested_set'

Or install as a plugin:

    rails plugin install git://github.com/skyeagle/nested_set.git

## Usage

To make use of nested_set, your model needs to have 3 fields: lft, rgt, and parent_id:

    class CreateCategories < ActiveRecord::Migration
      def self.up
        create_table :categories do |t|
          t.string :name
          t.integer :parent_id
          t.integer :lft
          t.integer :rgt

          # Uncomment it to store item level
          # t.integer :depth
        end
      end

      def self.down
        drop_table :categories
      end
    end

###NB: There is no reason to use depth column. It's only add additional queries to DB without benefit. If you need level you should use `each_with_level` instead.

Enable the nested set functionality by declaring acts_as_nested_set on your model

    class Category < ActiveRecord::Base
      acts_as_nested_set
    end

Run `rake rdoc` to generate the API docs and see CollectiveIdea::Acts::NestedSet::Base::SingletonMethods for more info.

### Conversion from other trees

Coming from acts_as_tree or another system where you only have a parent_id? No problem. Simply add the lft & rgt fields as above, and then run

    Category.rebuild!

Your tree be converted to a valid nested set.

## View Helper

The view helper is called #nested_set_options. 

Example usage:

    <%= f.select :parent_id, nested_set_options(Category, @category) {|i, level| "#{'-' * level} #{i.name}" } %>

    <%= select_tag 'parent_id', options_for_select(nested_set_options(Category) {|i, level| "#{'-' * level} #{i.name}" } ) %>

or sorted select:

    <%= f.select :parent_id, sorted_nested_set_options(Category, lambda(&:name)) {|i, level| "#{'-' * level} #{i.name}" } %>

    <% sort_method = lambda{|x| x.name.downcase} %>

NOTE: to sort UTF-8 strings you should use `x.name.mb_chars.downcase`

    <%= select_tag 'parent_id', options_for_select(sorted_nested_set_options(Category, sort_method){|i, level| "#{'-' * level} #{i.name}" } ) %>

See CollectiveIdea::Acts::NestedSet::Helper for more information about the helpers.

## Development

    bundle install

Running tests

    bundle exec rake test

Benchmark tests

    bundle exec ruby test/benchmark.rb

### References

You can learn more about nested sets at:

  [1](http://en.wikipedia.org/wiki/Nested_set_model)
  [2](http://www.ibase.ru/devinfo/DBMSTrees/9603d06.html)
  [3](http://threebit.net/tutorials/nestedset/tutorial1.html)
  [4](http://rdoc.info/github/rails/acts_as_nested_set/master/ActiveRecord/Acts/NestedSet/ClassMethods)
  [5](http://agilewebdevelopment.com/plugins/betternestedset)

## How to contribute

If you find what you might think is a bug:

1. Check the GitHub issue tracker to see if anyone else has had the same issue.
   [Issues tracker](http://github.com/skyeagle/nested_set/issues)
2. If you don't see anything, create an issue with information on how to reproduce it.

If you want to contribute an enhancement or a fix:

1. Fork the project on github. [http://github.com/skyeagle/nested_set](http://github.com/skyeagle/nested_set)
2. Make your changes with tests.
3. Commit the changes without making changes to the Rakefile, VERSION, or any other files that aren't related to your enhancement or fix
4. Send a pull request.

Copyright ©2010 Collective Idea, released under the MIT license

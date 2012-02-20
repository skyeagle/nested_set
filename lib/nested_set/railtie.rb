# encoding: utf-8
require 'nested_set'
require 'rails/railtie'

module CollectiveIdea
  module Acts
    module NestedSet
      class Railtie < ::Rails::Railtie
        config.before_initialize do
          ActiveSupport.on_load :active_record do
            include CollectiveIdea::Acts::NestedSet::Base
          end

          ActiveSupport.on_load :action_view do
            include CollectiveIdea::Acts::NestedSet::Helper
          end
        end

        def self.extend_active_record!
          ::ActiveRecord::Base.send :include, CollectiveIdea::Acts::NestedSet::Base
        end
      end
    end
  end
end

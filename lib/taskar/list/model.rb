module Taskar
  module List
    module Model
      def self.included(model)
        model.class_exec do
          extend ClassMethods
          include InstanceMethods

          attr_accessor :insert_before, :insert_after
        end
      end

      module ClassMethods
        def change_order_of(ids)
          if ids.is_a? Array
            position = 0
            ids.each do |id|
              find(id).update_attribute('position', position += 1)
            end
          end
        end
      end

      module InstanceMethods
        def add_to_list_bottom
          if insert_before && record = self.class.find(:first, :conditions => {:id => insert_before})
            increment_positions_on_lower_items record.position
            record.position -= 1
          elsif insert_after && record = self.class.find(:first, :conditions => {:id => insert_after})
            increment_positions_on_lower_items record.position + 1
          else
            record = bottom_item
          end

          self[position_column] = (record.try(:position) || 0 ) + 1
        end
      end
    end
  end
end
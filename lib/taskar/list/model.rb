module Taskar
  module List
    module Model
      def self.included(model)        
        model.class_exec do
          extend ClassMethods
          include InstanceMethods
          
          attr_accessor :insert_before
        end
      end
      
      module ClassMethods
        def reorder(ids)
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
          self[position_column] = if insert_before && record = self.class.find(:first, :conditions => {:id => insert_before})
            increment_positions_on_lower_items record.position
            record.position
          else
            bottom_position_in_list.to_i + 1
          end
        end
      end
    end
  end
end
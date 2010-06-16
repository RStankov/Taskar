module Taskar
  module SpecHelper
    def it_should_allow_mass_assignment_only_of(*attributes)
      attributes = attributes.map(&:to_s)
  
      subject.call.class.columns.map(&:name).each do |column|
        if attributes.include?(column)
          it { should allow_mass_assignment_of(column) }
        else
          it { should_not allow_mass_assignment_of(column) }
        end
      end
    end
    
    def it_should_have_counter_cache_of(name)
      class_name = subject.call.class.class_name.underscore
      
      it "should have counter_cache on #{name.to_s.classify}" do  
        counter = "#{class_name.pluralize}_count".to_sym
        
        parent  = Factory(name)
        parent[counter].should == 0
        
        1.upto 3 do
          Factory(class_name, { name => parent })
        end
    
        parent.reload[counter].should == 3
      end
    end
  end
end
module SpecSupport
  module Model
    module Validation
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

      def it_should_have_counter_cache_of(name, options = {})
        class_name = options.delete(:factory){ subject.call.class.name.underscore }

        it "haves counter cache on #{name.to_s.classify}" do
          counter = "#{class_name.pluralize}_count".to_sym

          parent  = create(name)
          parent[counter].should eq 0

          2.times { create class_name, name => parent }

          parent.reload[counter].should eq 2
        end
      end
    end
  end
end
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
  end
end
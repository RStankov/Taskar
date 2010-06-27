module Taskar
  module Auth
    module Model
      def self.included(model)        
        model.class_eval do
          before_save :downcase_email
          
          devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable
        end
      
        model.extend(ClassMethods)
        model.send(:include, InstanceMethods)
      end
      
      module ClassMethods
        def authenticate(conditions)
          conditions[:email].downcase! if conditions[:email]
          super(conditions)
        end
      end
      
      module InstanceMethods
        def downcase_email
          self.email = email.to_s.downcase
        end
      end
    end
  end
end
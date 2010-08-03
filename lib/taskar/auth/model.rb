module Taskar
  module Auth
    module Model
      def self.included(model)
        model.send(:before_save, :downcase_email)
        model.send(:devise, :database_authenticatable, :lockable, :recoverable, :rememberable, :trackable, :validatable, :registerable)
        model.extend(ClassMethods)
        model.send(:include, InstanceMethods)
      end
      
      module ClassMethods
        def authenticate(conditions)
          conditions[:email].downcase! if conditions[:email]
          super(conditions)
        end
        
        def send_unlock_instructions(attributes={})
         lockable = find_or_initialize_with_errors(attributes, I18n.t('devise.record.invalid'))
         lockable.resend_unlock_token unless lockable.new_record?
         lockable
        end
        
        def send_reset_password_instructions(attributes={})
          recoverable = find_or_initialize_with_errors(attributes, I18n.t('devise.record.invalid'))
          recoverable.send_reset_password_instructions unless recoverable.new_record?
          recoverable
        end
        
        def find_or_initialize_with_errors(attributes, error=:invalid)
          attributes = attributes.slice(*authentication_keys)
          attributes.delete_if { |k, v| !v.present? }
          
          if attributes.size == authentication_keys.size
            record = find(:first, :conditions => attributes)
          end
          
          unless record
            record = new
            record.send(:attributes=, attributes, false)
            
            if attributes.size == authentication_keys.size
              record.errors.add_to_base(error)
            else
              authentication_keys.reject { |k| attributes[k].present? }.each do |attribute|
                add_error_on(record, attribute, :blank, false)
              end
            end
          end

          record
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
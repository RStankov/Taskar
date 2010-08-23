module Taskar
  module NamedScopes
    def self.included(model)
      model.send :named_scope, :order, lambda { |order| { :order => order} } 
      model.send :named_scope, :limit, lambda { |limit| { :limit => limit} } 
      model.send :named_scope, :where, lambda { |where| { :conditions => where} }
    end
  end
end
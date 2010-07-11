Factory.define :account do |account|
  account.name            { Factory.next :name }
end

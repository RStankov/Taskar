Factory.define :account do |account|
  account.name            { Factory.next :name }
  account.domain          { Factory.next :name }
end

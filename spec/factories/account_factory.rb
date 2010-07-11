Factory.define :account do |account|
  account.name            { Factory.next :name }
  account.owner           { |a| a.association :user }
end

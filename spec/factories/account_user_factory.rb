Factory.define :account_user do |object|
  object.account       { |a| a.association :account }
  object.user          { |a| a.association :user }
end

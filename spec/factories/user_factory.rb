Factory.sequence :email do |n|
  "user_#{rand(100)}_#{n}@domain.com"
end

Factory.define :user do |user|
  user.email                  { Factory.next :email }
  user.account                { |a| a.association :account }
  user.first_name             { "Firstname" }
  user.last_name              { "Lastname"  }
  user.password               { "password"  }
  user.password_confirmation  { "password"  }
  user.admin                  false
end
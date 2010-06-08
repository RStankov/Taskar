Factory.sequence :email do |n|
  "user#{n}@domain.com"
end

Factory.define :user do |user|
  user.email                  { Factory.next :email }
  user.first_name             { "Firstname" }
  user.last_name              { "Lastname" }
  user.password               { "password" }
  user.password_confirmation  { "password" }
end

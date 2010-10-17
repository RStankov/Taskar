Factory.define :invitation do |object|
  object.association    :account
  object.email          { Factory.next :email }
  object.first_name     "FirstName"
  object.last_name      "LastName"
end

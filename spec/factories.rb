FactoryGirl.define do
  sequence(:name)  { |n| "generated_name_#{n}" }
  sequence(:email) { |n| "user_#{rand(100)}_#{n}@domain.com" }

  factory :account do
    name { Factory.next :name }
  end

  factory :account_user do
    association :account
    association :user
  end

  factory :comment do
    association :user
    association :task
    association :project
    text        'Comment Text'
  end

  factory :event do
    association :user
    association :subject, :factory => :task
    action      'created'
    info        'Section "Foo" created'
  end

  factory :invitation do
    association :account
    email       { Factory.next :email }
    first_name  'FirstName'
    last_name   'LastName'
  end

  factory :project do
    name        { Factory.next :name }
    association :account
  end

  factory :project_user do
    association :project
    association :user
  end

  factory :section do
    name        'Test section'
    association :project
  end

  factory :status do
    association :user
    association :project
    text        'doing something'
  end

  factory :task do
    association :section
    association :user
    text        'Task Text'
    status      0
  end

  factory :user do
    email                  { Factory.next :email }
    first_name             { 'Firstname' }
    last_name              { 'Lastname'  }
    password               { 'password'  }
    password_confirmation  { 'password'  }
  end
end
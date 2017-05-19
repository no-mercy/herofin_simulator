FactoryGirl.define do
  factory :user do
    name 'John Doe'
  end

  factory :account do
    available_money 100
  end

  factory :operation do
    amount 1
    name 'Testing operation'
  end

  factory :finance_profile

  factory :hr_profile
end

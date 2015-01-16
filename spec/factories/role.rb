FactoryGirl.define do
  factory :role do
    name { Faker::Name.name }
    billable 0

    factory :role_invalid do
      name nil
    end

    factory :role_billable do
      name 'senior'
      billable 1
      technical true
    end

    factory :role_admin do
      name 'senior'
      admin true
    end
  end
end

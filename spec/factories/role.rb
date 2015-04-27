FactoryGirl.define do
  factory :role do
    name { Faker::Name.name }
    billable 0
    priority 0

    factory :role_invalid do
      name nil
    end

    factory :role_billable do
      name 'senior'
      billable 1
      technical true
    end

    factory :technical_role do
      technical true
    end

    factory :junior_role do
      name 'junior'
      technical true
    end

    factory :dev_role do
      name 'developer'
      technical true
    end

    factory :senior_role do
      name 'senior'
      technical true
    end

    factory :pm_role do
      name 'pm'
      technical false
    end

    factory :qa_role do
      name 'qa'
      technical false
    end
  end
end

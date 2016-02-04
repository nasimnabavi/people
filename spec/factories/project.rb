FactoryGirl.define do
  factory :project do
    sequence(:name) { |i| "#{Faker::Internet.domain_word}_#{i}" }
    starts_at { 90.days.from_now }
    end_at { 30.days.from_now }
    archived false
    project_type { 'regular' }
    synchronize true
    memberships []

    factory :project_deleted do
      deleted_at Time.now
    end

    factory :invalid_project do
      name nil
    end

    trait :potential do
      potential true
    end

    trait :archived do
      archived true
    end

    trait :without_due_date do
      end_at nil
    end

    trait :commercial do
      internal false
    end

    trait :internal do
      internal true
    end

    trait :maintenance do
      project_type { 'maintenance' }
      maintenance_since { Time.now - 7.days }
    end
  end
end

FactoryGirl.define do
  factory :position do
    starts_at { Date.new(2014, 5, 9) }
    primary false
    user
    role
  end
end


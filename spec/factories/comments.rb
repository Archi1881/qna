FactoryBot.define do
  factory :comment do
    user
    content { 'MyText' }

    trait :invalid do
      content { nil }
    end
  end
end

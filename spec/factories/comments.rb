FactoryBot.define do
  factory :comment do
    content { "MyText" }

    trait :invalid do
      content { nil }
    end    
  end
end

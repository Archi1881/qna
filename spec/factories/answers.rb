FactoryBot.define do
  factory :answer do
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end

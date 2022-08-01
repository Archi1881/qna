FactoryBot.define do
  factory :answer do
    body { "MyText" }

    trait :invalid do
      body { nil }
    end

    factory :q_answers do
      sequence(:body) do |n| 
        "#{n}. Some Answer"
      end
    end
  end
end

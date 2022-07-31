FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    factory :s_questions do
      sequence(:title) do |n|
        "#{n} Some Title"
      end

      sequence(:body) do |n| 
        "#{n} Some Body"
      end
    end
  end
end

FactoryBot.define do
  factory :vote do
    score { 1 }
    association :user
  end
end

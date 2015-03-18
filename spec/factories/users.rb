FactoryGirl.define do
  factory :user do
    sequence(:email)    { |index| "address_#{index}@box.com" }
    sequence(:password) { |index| "password#{index}" }

    trait :subscribed do
      subscribed true
    end

    trait :confirmed do
      confirmed_at Time.now
    end

    factory :confirmed_user,  traits: [:confirmed]
    factory :subscribed_user, traits: [:subscribed, :confirmed]

    factory :active_user do
      transient do
        comments_count 5
      end

      after :create do |user, evaluator|
        create_list :queued_comment, evaluator.comments_count, author: user
      end
    end
  end
end

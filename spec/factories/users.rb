FactoryGirl.define do
  factory :user do
    sequence(:email)    { |index| "address_#{index}@box.com" }
    sequence(:password) { |index| "password#{index}" }

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
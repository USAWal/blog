FactoryGirl.define do
  factory :comment do
    article

    body <<BODY
Lorem ipsum dolor sit amet, te ius quod eloquentiam. Vel ceteros forensibus definitionem ei, sit ne pertinax percipitur. Nibh aperiri pertinacia ne pri, dicat nusquam mediocritatem sea ei. Vis falli facilis salutatus eu, eirmod verear euismod et eum.
BODY

    trait :queued do
      sequence(:created_at) { |counter| Time.now + counter.seconds }
    end

    factory :queued_comment, traits: [:queued]
  end
end

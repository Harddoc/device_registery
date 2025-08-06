FactoryBot.define do
  factory :device do
    serial_number { SecureRandom.hex(6) }
    owner { nil }

    trait :with_owner do
      association :owner, factory: :user
    end
  end
end
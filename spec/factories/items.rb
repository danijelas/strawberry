FactoryBot.define do
  factory :item do
    category
    name {Faker::Name.name}
    description {Faker::Lorem.sentence}
    price {Faker::Number.decimal(8,2)}
    done {[true, false].sample}
    list
  end
end
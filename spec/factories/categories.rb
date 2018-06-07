FactoryBot.define do
  factory :category do
    name {Faker::Name.name}
    user
  end
end
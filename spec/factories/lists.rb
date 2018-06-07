FactoryBot.define do
  factory :list do
    name {Faker::Name.name}
    user
  end
end
# Arquivo criar objetos pra teste

FactoryGirl.define do
  factory :user do
    # Campos que devem ser preenchidos
    email { Faker::Internet.email }
    password '123456'
    password_confirmation '123456'
  end
end

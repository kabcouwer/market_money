FactoryBot.define do
  factory :market do
    name { Faker::TvShows::RuPaul.queen }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { Faker::Address.community }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end

  factory :vendor do
    name { Faker::Restaurant.name }
    description { Faker::ChuckNorris.fact }
    contact_name { Faker::GreekPhilosophers.name }
    contact_phone { Faker::PhoneNumber.cell_phone_in_e164 }
    credit_accepted { Faker::Boolean.boolean }
  end

  factory :market_vendor do
    market
    vendor
  end
end

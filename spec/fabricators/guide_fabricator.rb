Fabricator(:guide) do
  birthdate { Faker::Date.birthday(18,30) }
  main_phone { Faker::PhoneNumber.cell_phone }
  bio { Faker::Lorem.sentence(10) }
  status "approved"
  user
end

Fabricator(:invalid_guide, from: :guide) do
  birthdate ""
  main_phone ""
  bio ""
end

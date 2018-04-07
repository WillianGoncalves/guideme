Fabricator(:contract) do
  start_date 1.day.from_now
  end_date 2.days.from_now
  goals Faker::Lorem.paragraph
  contractor { Fabricate :user }
  guide
end

Fabricator(:invalid_contract, from: :contract) do
  start_date nil
  end_date nil
  goals ""
end

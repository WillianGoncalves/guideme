Fabricator(:academic_education) do
  course { Faker::Educator.course }
  institution { Faker::Educator.university }
  level "bachelor"
end

Fabricator(:elementary, from: :academic_education) do
  course { Faker::Educator.course }
  institution { Faker::Educator.university }
  level "elementary"
end

Fabricator(:high_school, from: :academic_education) do
  course { Faker::Educator.course }
  institution { Faker::Educator.university }
  level "high_school"
end

Fabricator(:technician, from: :academic_education) do
  course { Faker::Educator.course }
  institution { Faker::Educator.university }
  level "technician"
end

Fabricator(:bachelor, from: :academic_education) do
  course { Faker::Educator.course }
  institution { Faker::Educator.university }
  level "bachelor"
end

Fabricator(:master, from: :academic_education) do
  course { Faker::Educator.course }
  institution { Faker::Educator.university }
  level "master"
end

Fabricator(:doctor, from: :academic_education) do
  course { Faker::Educator.course }
  institution { Faker::Educator.university }
  level "doctor"
end

Fabricator(:phd, from: :academic_education) do
  course { Faker::Educator.course }
  institution { Faker::Educator.university }
  level "phd"
end

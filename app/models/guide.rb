class Guide < User
  validates :birthdate, presence: true
  validates :main_phone, presence: true, length: { minimum: 10 }
  validates :bio, presence: true, length: { minimum: 10 }
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :guide
  validates :name, presence: true, length: { minimum: 5 }

  def guide?
    self.guide.present? and self.guide.approved?
  end

  def guide_candidate?
    self.guide.present? and self.guide.awaiting_for_approval?
  end
end

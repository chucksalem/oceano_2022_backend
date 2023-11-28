class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  enum role: [:admin]

  has_many :bookings

  def admin?
   self.role == 'admin'
  end
end

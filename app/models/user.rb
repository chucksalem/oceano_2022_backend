class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  enum role: [:admin]

  def admin?
   self.role == 'admin'
  end
end

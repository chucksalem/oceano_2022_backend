class User < ApplicationRecord
  devise :database_authenticatable, :validatable
  has_many :blogs, dependent: :delete_all
  enum role: [:admin]

  def admin?
   self.role == 'admin'
  end
end

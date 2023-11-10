# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  enum role: { admin: 0 }

  def admin?
    role == 'admin'
  end
end

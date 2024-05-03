class Subscription < ApplicationRecord
  validates :email, presence: true, uniqueness: true
end

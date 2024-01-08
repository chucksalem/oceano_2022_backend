# app/models/blog.rb

class Blog < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true

  scope :admin_only, ->(user) { where(admin_only: true) if user.admin? }
end

# app/models/blog.rb

class Blog < ApplicationRecord
  belongs_to :user
  has_one_attached :title_image
  has_many_attached :images

  # validates :title_image, :images, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 5.megabytes }
  validates :title, presence: true
  validates :content, presence: true

  scope :admin_only, ->(user) { where(admin_only: true) if user.admin? }
end

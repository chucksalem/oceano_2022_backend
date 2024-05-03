# app/models/blog.rb

class Blog < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true

  scope :admin_only, ->(user) { where(admin_only: true) if user.admin? }

  def should_generate_new_friendly_id?
    slug.blank? || slug == "undefined"
  end
  def def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end
end

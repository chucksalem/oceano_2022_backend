require "administrate/base_dashboard"

class BlogDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    title: Field::String,
    content: Field::Text,
    admin_only: Field::Boolean,
    user: Field::BelongsTo.with_options(class_name: "User"),
    image_data: Field::String, # Assuming handling of image data as a URL or identifier
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    title
    user
    admin_only
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    title
    content
    user
    admin_only
    image_data
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    title
    content
    user
    admin_only
    image_data # Adjust based on how you plan to handle image uploads or references
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(blog)
    "Blog ##{blog.id} - #{blog.title}"
  end
end

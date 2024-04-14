# _blog.json.jbuilder

json.id blog.id
json.slug blog.slug
json.title blog.title
json.meta_desc blog.meta_desc
json.meta_title blog.meta_title
json.content blog.content
json.image_data blog.image_data if blog.image_data.present?
json.created_at blog.created_at

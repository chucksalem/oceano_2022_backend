# _blog.json.jbuilder

json.id blog.id
json.title blog.title
json.content blog.content
json.image_data Base64.encode64(blog.image_data) if blog.image_data.present?
json.created_at blog.created_at

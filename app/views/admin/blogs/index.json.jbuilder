# app/views/admin/blogs/index.json.jbuilder

json.blogs @blogs do |blog|
  json.partial! 'api/v1/shared/blog', blog: blog
end



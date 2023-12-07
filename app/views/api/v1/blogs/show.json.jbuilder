# app/views/api/v1/blogs/show.json.jbuilder

json.blog do
    json.partial! 'api/v1/shared/blog', blog: @blog
end

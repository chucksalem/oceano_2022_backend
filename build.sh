docker-compose up --build --detach
docker exec -it rails /bin/sh
bundle exec rake oceano:cache:properties
exit

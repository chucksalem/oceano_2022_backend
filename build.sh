docker stop oceano_2022_backend-frontend-1
docker rm oceano_2022_backend-frontend-1
docker rmi chucksalem/oceano-frontend
docker-compose up --build --detach
# docker exec -it rails /bin/sh
# bundle exec rake oceano:cache:properties
# exit

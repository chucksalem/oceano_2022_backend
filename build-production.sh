cd /root/apps/oceano_2022_backend
git pull origin rc-production -f
docker-compose down
docker stop oceano_2022_backend_frontend_1
docker rm oceano_2022_backend_frontend_1
docker rmi chucksalem/oceano-frontend:rc-prod
docker-compose up --build --detach

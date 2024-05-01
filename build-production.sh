cd /root/apps/oceano_2022_backend
docker-compose down
git pull origin rc-production -f
docker rmi chucksalem/oceano-frontend:rc_prod
docker-compose up --build --detach

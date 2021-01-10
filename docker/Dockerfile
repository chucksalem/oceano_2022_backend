FROM ruby:2.4.9

# install essentials, node, and bash preferences
RUN echo "alias l='ls -lahAF'" > /root/.bashrc && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update -qq && apt-get install -y \
    nodejs npm vim build-essential wget ca-certificates redis-server \
    postgresql libpq-dev sqlite libsqlite-dev

WORKDIR /app
COPY . .
RUN bin/setup

ENTRYPOINT docker/entrypoint.sh

FROM ruby:3.1.4

# install essentials, node, and bash preferences
# RUN echo "alias l='ls -lahAF'" > /root/.bashrc && \
#     curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
#     apt-get update -qq && apt-get install -y \
#     nodejs npm vim build-essential wget ca-certificates redis-server \
#     postgresql libpq-dev sqlite libsqlite-dev

RUN echo "alias l='ls -lahAF'" > /root/.bashrc && \
    apt-get update -qq && apt-get install -y \
    nodejs npm vim build-essential wget ca-certificates redis-server \
    postgresql libpq-dev sqlite3 libsqlite3-dev cron

WORKDIR /app
COPY . .
# RUN bin/setup

RUN bundle config set --local path 'vendor'
RUN gem install bundler --conservative
RUN bundle config --global jobs 4 && \
    bundle install
RUN cp .env.sample .env
RUN bundle exec whenever --update-crontab

ARG PORT=3000
ENV PORT=${PORT}
EXPOSE ${PORT}

ENTRYPOINT ["./entrypoint.sh"]

CMD [ "/bin/bash" ]


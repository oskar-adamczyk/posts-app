FROM ruby:3.0.3-alpine3.13 as prod

RUN apk update && \
  apk -q --update --no-cache add \
  build-base \
  libxml2-dev \
  libxslt-dev \
  ruby-dev \
  libpq \
  postgresql \
  postgresql-client \
  postgresql-dev
RUN bundle config --global frozen 1

ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=1

WORKDIR /app

COPY Gemfile Gemfile.lock Rakefile ./

RUN BUNDLE_WITHOUT=development:test bundle install

COPY . ./

CMD ["sh", "/app/docker/entrypoint.sh"]

FROM prod as dev

RUN BUNDLE_WITH=development:test bundle install

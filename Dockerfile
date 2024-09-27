# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
FROM ruby:3.2.2-alpine AS builder
RUN apk add build-base git nodejs yarn

COPY Gemfile* ./
RUN bundle install

FROM ruby:3.2.2-alpine AS runner
RUN apk add build-base git nodejs yarn

WORKDIR /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY . .
RUN yarn install
RUN bundle exec hanami assets compile


EXPOSE 2300
CMD ["bundle", "exec", "hanami", "server", "--host", "0.0.0.0"]

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
FROM ruby:3.2.2-alpine AS builder
RUN apk add build-base git

COPY Gemfile* ./
RUN bundle install

FROM ruby:3.2.2-alpine AS runner

WORKDIR /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY . .

RUN bundle exec hanami assets compile

EXPOSE 2300
CMD ["bundle", "exec", "hanami", "server", "--host", "0.0.0.0"]

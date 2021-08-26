FROM ruby:3.0.0 as builder
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client && mkdir /code
WORKDIR /code
COPY Gemfile /code/Gemfile
COPY Gemfile.lock /code/Gemfile.lock
RUN bundle install

FROM builder as development
CMD ["rails", "server", "-b", "0.0.0.0"]

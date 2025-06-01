FROM ruby:3.4.1

WORKDIR /usr/src/app

COPY ./Gemfile ./Gemfile
COPY ./Gemfile.lock ./Gemfile.lock

RUN bundle install

COPY . .

CMD [ "bin/dev" ]
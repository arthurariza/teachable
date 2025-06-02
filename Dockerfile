ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

RUN apt update -qq && apt upgrade -y
RUN apt install -y build-essential
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update -qq
RUN apt install -y nodejs yarn
RUN gem update --system
RUN gem install bundle

WORKDIR /app
RUN echo 'gem: --no-rdoc --no-ri >> "$HOME/.gemrc"'

COPY Gemfile Gemfile.lock ./
COPY package.json yarn.lock ./

RUN bundle install -j $(nproc)
RUN yarn install
FROM ruby:2.4.10-buster

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common curl build-essential \
    wget procps git-core vim  \
    zlib1g-dev libxml2-dev libsqlite3-dev \
    libpq-dev libxmlsec1-dev curl make g++ locales \
    sudo python-pygments

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sf https://gobinaries.com/tj/node-prune | bash
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y  nodejs yarn

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

ADD canvas.tar.gz /var/canvas
WORKDIR /var/canvas

RUN gem install bundler --version 1.13.6
RUN bundle _1.13.6_ install --path vendor/bundle --without=test --clean
RUN yarn install

RUN RAILS_ENV=production bundle exec rake canvas:compile_assets
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN node-prune

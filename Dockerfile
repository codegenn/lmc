# syntax = docker/dockerfile:experimental
FROM 373728140326.dkr.ecr.ap-southeast-1.amazonaws.com/lmcation:2.6.0

ARG BUNDLER_VERSION="1.15.3"
ARG RAILS_ROOT=/lmcation
ARG RAILS_ENV

RUN sed -i -e "s/deb.debian.org/cloudfront.debian.net/g" /etc/apt/sources.list \
    &&  apt-get update -y \
    &&  apt-get install libsasl2-modules psmisc -y \
    &&  apt-get autoremove \
    &&  apt-get autoclean \
    &&  apt-get clean \
    &&  gem install bundler -v ${BUNDLER_VERSION}

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libpq-dev &&\
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn

RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
    && echo "postfix postfix/mailname string \$myhostname" | debconf-set-selections \
    && apt-get install postfix -y

# bundle install
WORKDIR ${RAILS_ROOT}
COPY ./Gemfile ./Gemfile.lock ./

RUN --mount=type=cache,target=.cache/bundle,id=lmcation-bundle \
    cp -arT .cache/bundle $(gem environment gemdir) \
    &&  bundle install --jobs=3 --retry=5 \
    &&  bundle clean --force \
    &&  cp -arT $(gem environment gemdir) .cache/bundle

COPY ./ .

RUN /bin/bash -c bundle exec rake assets:precompile -e production

EXPOSE 8080
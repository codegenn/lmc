# syntax = docker/dockerfile:experimental
FROM ruby:2.6.0

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

RUN apt-get update -qq && \
    apt-get install -y nodejs

# bundle install
WORKDIR ${RAILS_ROOT}
COPY ./Gemfile ./Gemfile.lock ./

RUN bundle install --jobs 4 --retry 3

COPY . /.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

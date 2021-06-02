ARG BUNDLER_VERSION=2.0.2
ARG RUBY_VERSION=2.7.1
ARG APP_ROOT=/gem

#######################################
###           Builder
FROM ruby:${RUBY_VERSION}-alpine AS build-env

ARG APP_ROOT

ENV BUNDLE_APP_CONFIG="$APP_ROOT/.bundle"
ARG PACKAGES="curl tzdata less git"
RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $PACKAGES

#######################################
###           Development
FROM build-env AS development

ARG BUNDLER_VERSION
ARG APP_ROOT
ENV BUNDLE_APP_CONFIG="$APP_ROOT/.bundle"

WORKDIR $APP_ROOT

RUN apk add --update --no-cache \
  build-base \
  git \
  tzdata \
  less

RUN gem install bundler:$BUNDLER_VERSION

COPY . $APP_ROOT

RUN bundle install -j4 --retry 3 \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete



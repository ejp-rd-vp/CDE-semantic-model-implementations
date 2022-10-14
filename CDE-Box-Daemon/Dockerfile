FROM ruby:3.0.0

RUN apt-get -y update
RUN apt-get -y install git
RUN gem install bundler:2.2.10
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN mkdir -p /app


COPY . /app

WORKDIR /app


RUN bundle install
RUN gem install *.gem

RUN git clone https://github.com/ejp-rd-vp/CDE-semantic-model-implementations.git

ENTRYPOINT ["sh", "entrypoint.sh"]

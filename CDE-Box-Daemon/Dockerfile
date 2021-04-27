FROM ruby:2.7.2

RUN apt-get -y update
RUN apt-get -y install git-all
RUN gem install bundler:2.2.10
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN mkdir -p /app
RUN mkdir -p /data
RUN mkdir -p /config


COPY . /app

WORKDIR /app


RUN bundle install
RUN gem install *.gem

RUN git clone https://github.com/ejp-rd-vp/CDE-semantic-model-implementations.git
RUN cp CDE-semantic-model-implementations/YARRRRML_Transform_Templates/*.yaml /config

ENTRYPOINT ["sh", "entrypoint.sh"]

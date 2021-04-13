FROM ruby:2.7.2
RUN gem install bundler:2.2.10

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN mkdir -p /app
#RUN mkdir -p /config
COPY . /app
#COPY Gemfile Gemfile.lock ./
WORKDIR /app
#RUN cp ./config/* /config/
RUN bundle install
RUN gem install *.gem

ENTRYPOINT ["ruby", "./bin/serve_triples"]

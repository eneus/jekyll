FROM ubuntu
RUN apt update && apt -y upgrade && apt -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev rubygems ruby-dev
RUN mkdir -p /srv/html
RUN gem install \
  github-pages \
  jekyll bundler \
  jekyll-redirect-from \
  kramdown \
  rdiscount \
  rouge \
  jekyll-paginate \
  jekyll-admin
RUN cd /root && bundle install
EXPOSE 4000
WORKDIR /srv/html
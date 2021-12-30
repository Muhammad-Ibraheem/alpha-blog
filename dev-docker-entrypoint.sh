#!/bin/sh

set -e

echo "ENVIRONMENT: $RAILS_ENV"

#check bundle

bundle check || bundle install

bundle exec rake db:prepare

#remove pid from previous session (puma server)
rm -f $APP_PATH/tmp/pids/server.pid


bundle exec ${@}

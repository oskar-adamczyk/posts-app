#!/bin/sh

until nc -z $DATABASE_HOST $DATABASE_PORT; do sleep 1; done

rake db:create
rake db:migrate || exit 1
rspec || exit 1

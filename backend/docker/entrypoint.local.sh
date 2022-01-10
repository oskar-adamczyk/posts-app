#!/bin/sh

rake db:create
rake db:migrate || exit 1
# rake db:seed || exit 1

ruby main.rb

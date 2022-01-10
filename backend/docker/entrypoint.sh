#!/bin/sh

rake db:migrate || exit 1

ruby main.rb
#!/usr/bin/env bash

set -e
bundle exec srb tc
bundle exec rubocop
ruby -I lib:test -r 'minitest/autorun' test/all.rb

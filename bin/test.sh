#!/usr/bin/env bash

set -e
bundle exec srb tc --metrics-file /tmp/sorbet_metrics.json
ruby -I lib \
  -r sorbet_progress \
  -e 'SorbetProgress::CLI.new(["/tmp/sorbet_metrics.json"]).run'
bundle exec rubocop
ruby -I lib:test -r 'minitest/autorun' test/all.rb

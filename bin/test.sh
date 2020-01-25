#!/usr/bin/env bash

set -e

bundle exec srb tc --metrics-file /tmp/sorbet_metrics.json
bundle exec bin/sorbet_progress --reporter bar_chart /tmp/sorbet_metrics.json
bundle exec rubocop
bundle exec ruby -I lib:test test/all.rb

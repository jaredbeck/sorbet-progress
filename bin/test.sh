#!/usr/bin/env bash

set -e

bundle exec srb tc --metrics-file /tmp/sorbet_metrics.json

# TODO: Doesn't work on travis. No idea why.
#
# ```
# Traceback (most recent call last):
# 	4: from /home/travis/.rvm/rubies/ruby-2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# 	3: from /home/travis/.rvm/rubies/ruby-2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# 	2: from /home/travis/build/jaredbeck/sorbet-progress/lib/sorbet_progress.rb:4:in `<top (required)>'
# 	1: from /home/travis/.rvm/rubies/ruby-2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# /home/travis/.rvm/rubies/ruby-2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require': cannot load such file -- sorbet-runtime
# ```
if [ "$TRAVIS" != 'true' ]; then
  bundle exec ruby -I lib \
    -r sorbet_progress \
    -e 'SorbetProgress::CLI.new(["/tmp/sorbet_metrics.json"]).run'
fi

bundle exec rubocop

# TODO: This `bundle exec ruby` also doesn't work on travis.
#
# ```
# home/travis/.rvm/gems/ruby-2.6.5/gems/bundler-2.1.3/lib/bundler/runtime.rb:312:in
# `check_for_activated_spec!': You have already activated minitest 5.11.3, but
# your Gemfile requires minitest 5.13.0. Prepending `bundle exec` to your
# command may solve this. (Gem::LoadError)
# ```
if [ "$TRAVIS" != 'true' ]; then
  bundle exec ruby -I lib:test -r 'minitest/autorun' test/all.rb
fi

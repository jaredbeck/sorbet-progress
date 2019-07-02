#!/usr/bin/env bash

ruby -I lib:test -r 'minitest/autorun' test/all.rb

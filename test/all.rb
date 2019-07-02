# frozen_string_literal: true

# typed: false
# A simple replacement for Rake::TestTask. Assumes that the `test` directory
# is already on the LOAD_PATH. See bin/test.sh
Dir.glob('test/**/*_test.rb').each do |file|
  require File.join(*file.split(File::SEPARATOR).drop(1))
end

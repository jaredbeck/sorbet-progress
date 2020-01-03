# typed: strong
# frozen_string_literal: true

require "sorbet-runtime"

module SorbetProgress
  # A simple replacement for Rake::TestTask. Assumes that the `test` directory
  # is already on the LOAD_PATH. See bin/test.sh
  class TestTask
    extend T::Sig

    sig { void }
    def run
      Dir.glob("test/**/*_test.rb").each do |path|
        require drop_first_path_segment(path)
      end
    end

    private

    sig { params(path: String).returns(String) }
    def drop_first_path_segment(path)
      path.split(File::SEPARATOR).drop(1).join(File::SEPARATOR)
    end
  end
end

# Prevent eg. `srb init` from accidentally running tests.
if __FILE__ == $PROGRAM_NAME
  SorbetProgress::TestTask.new.run
end

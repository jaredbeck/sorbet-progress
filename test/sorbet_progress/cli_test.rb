# typed: true
# frozen_string_literal: true

require "test_helper"

module SorbetProgress
  class CLITest < Minitest::Test
    def test_run
      path = File.expand_path("../fixtures/01.json", __dir__)
      cli = CLI.new([path])
      assert_output(/Sorbet Progress/) { cli.run }
    end
  end
end

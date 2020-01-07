# typed: true
# frozen_string_literal: true

require "test_helper"

module SorbetProgress
  module Reporters
    class VerboseTest < Minitest::Test
      def test_report_01
        path = File.expand_path("../../fixtures/01.json", __dir__)
        metrics = Parser.new.parse(File.read(path))
        calc = Calculator.new(metrics)
        reporter = Verbose.new(calc)
        expected_output_path = File.expand_path(
          "../../fixtures/01_verbose.txt",
          __dir__
        )
        expected_output = File.read(expected_output_path)
        assert_equal(expected_output.strip, reporter.report)
      end
    end
  end
end

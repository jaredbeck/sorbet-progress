# typed: true
# frozen_string_literal: true

require "test_helper"
require "sorbet_progress/reporters/bar_chart"

module SorbetProgress
  module Reporters
    class BarChartTest < Minitest::Test
      def test_report_01
        path = File.expand_path("../../fixtures/01.json", __dir__)
        metrics = Parser.new.parse(File.read(path))
        calc = Calculator.new(metrics)
        reporter = BarChart.new(calc)

        # The fixture file is in "dump" format, á la `String.dump`. It's the
        # only format I could think that would allow me to have a fixture file.
        expected_output_path = File.expand_path(
          "../../fixtures/01_bar_chart.dump",
          __dir__
        )
        expected_output = File.read(expected_output_path)
        assert_equal(expected_output.strip, reporter.report.dump)
      end
    end
  end
end

# frozen_string_literal: true

# typed: true

require "sorbet_progress/calculator"
require "sorbet_progress/error"
require "sorbet_progress/metrics"
require "sorbet_progress/parser"
require "sorbet_progress/reporters/bar_chart"
require "sorbet_progress/reporters/base"
require "sorbet_progress/reporters/verbose"

module SorbetProgress
  # Parses the provided metrics file and prints a report.
  class CLI
    extend T::Sig

    USAGE = <<~EOS
      Usage: sorbet_progress [--reporter name] /path/to/sorbet_metrics.json
      Reporters: bar_chart, verbose
    EOS

    sig { params(argv: T::Array[String]).void }
    def initialize(argv)
      # TODO: use an actual CLI args parser, like optparse or trollop
      case argv.length
      when 1
        @path = argv.first
        @reporter_name = "verbose"
      when 3
        @path = argv.last
        @reporter_name = argv[1]
      else
        raise Error.new(1, USAGE)
      end
    end

    sig { void }
    def run
      metrics = parse(@path)
      calculator = Calculator.new(metrics)
      reporter = reporter_class(@reporter_name).new(calculator)
      puts reporter.report
    end

    private

    sig { params(path: String).returns(Metrics) }
    def parse(path)
      Parser.new.parse(File.read(path))
    rescue Errno::ENOENT => e
      raise Error.new(2, "Metrics file not found: " + e.message)
    end

    sig { params(name: String).returns(T.class_of(Reporters::Base)) }
    def reporter_class(name)
      case name
      when "verbose"
        Reporters::Verbose
      when "bar_chart"
        Reporters::BarChart
      else
        raise format("Invalid reporter name: %s", @reporter_name)
      end
    end
  end
end

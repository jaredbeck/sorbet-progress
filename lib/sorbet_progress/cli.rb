# frozen_string_literal: true

# typed: true

require "sorbet_progress/calculator"
require "sorbet_progress/error"
require "sorbet_progress/metrics"
require "sorbet_progress/parser"
require "sorbet_progress/reporters/verbose"

module SorbetProgress
  # Parses the provided metrics file and prints a report.
  class CLI
    extend T::Sig

    USAGE = <<~EOS
      Usage: sorbet_progress /path/to/sorbet_metrics.json
    EOS

    sig { params(argv: T::Array[String]).void }
    def initialize(argv)
      unless argv.length == 1
        raise Error.new(1, USAGE)
      end
      @path = argv.first
    end

    sig { void }
    def run
      metrics = parse(@path)
      calculator = Calculator.new(metrics)
      reporter = Reporters::Verbose.new(calculator)
      puts reporter.report
    end

    private

    sig { params(path: String).returns(Metrics) }
    def parse(path)
      Parser.new.parse(File.read(path))
    rescue Errno::ENOENT => e
      raise Error.new(2, "Metrics file not found: " + e.message)
    end
  end
end

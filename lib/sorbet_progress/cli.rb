# frozen_string_literal: true

# typed: true

require "sorbet_progress/calculator"
require "sorbet_progress/error"
require "sorbet_progress/metrics"
require "sorbet_progress/parser"

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
      puts "Sorbet Progress\n\n"

      stats_calculator = Calculator.new(metrics)

      puts "Progress for sig coverage"
      stats_calculator.coverage_metrics.each do |label, value|
        puts format_metric(label, value)
      end

      puts "\nProgress for file coverage"

      stats_calculator.sigil_percentages.each do |elem|
        percentage =
          if elem[:percentage]
            elem[:percentage] * 100
          else
            0
          end
        puts format("%-17s\t%d\t%.2f %%", elem[:label], elem[:value] || 0, percentage)
      end

      puts "---------------------------------------"
      puts "Total: \t\t\t#{stats_calculator.total}\t100%"

      puts "Keep up the good work 👍"
    end

    private

    sig { params(path: String).returns(Metrics) }
    def parse(path)
      Parser.new.parse(File.read(path))
    rescue Errno::ENOENT => e
      raise Error.new(2, "Metrics file not found: " + e.message)
    end

    # Format a label and metric value into a presentable String.
    sig { params(label: Symbol, value: Integer).returns(String) }
    def format_metric(label, value)
      if value.nil?
        format("%-17s\tunknown", label)
      else
        format("%-17s\t%d", label, value)
      end
    end
  end
end

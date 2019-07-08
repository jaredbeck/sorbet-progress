# frozen_string_literal: true

# typed: true

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
      puts "SorbetProgress:"
      {
        total_signatures: "ruby_typer.unknown..types.sig.count",
        total_methods: "ruby_typer.unknown..types.input.methods.total",
        total_classes: "ruby_typer.unknown..types.input.classes.total",
        sigil_ignore: "ruby_typer.unknown..types.input.files.sigil.ignore",
        sigil_false: "ruby_typer.unknown..types.input.files.sigil.false",
        sigil_true: "ruby_typer.unknown..types.input.files.sigil.true",
        sigil_strict: "ruby_typer.unknown..types.input.files.sigil.strict",
        sigil_strong: "ruby_typer.unknown..types.input.files.sigil.strong"
      }.each do |label, name|
        metric = metrics[name]
        if metric.nil?
          print_metric_not_found(label)
        else
          print_metric(label, metric.value)
        end
      end
      puts "Keep up the good work 👍"
    end

    private

    sig { params(path: String).returns(Metrics) }
    def parse(path)
      Parser.new.parse(File.read(path))
    rescue Errno::ENOENT => e
      raise Error.new(2, "Metrics file not found: " + e.message)
    end

    def print_metric(label, value)
      puts format("%-17s\t%d", label, value)
    end

    def print_metric_not_found(label)
      puts format("%-17s\tunknown", label)
    end
  end
end

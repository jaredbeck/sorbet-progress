# frozen_string_literal: true

# typed: true

module SorbetProgress
  # Computes the percentage stats for sigil metrics as well as other stats.
  class Calculator
    extend T::Sig

    attr_reader :total, :sigil_percentages, :coverage_metrics

    sig { params(metrics: Metrics).void }
    def initialize(metrics)
      values = collect_values(sigil_breakdown_stats, metrics)
      @total = values.delete(:total_files)

      @sigil_percentages = values.map do |label, value|
        percentage = value * 1.0 / @total if @total && value
        {
          label: label,
          value: value,
          percentage: percentage
        }
      end

      @coverage_metrics = collect_values(coverage_stats, metrics)
    end

    private

    # Mapping of general coverage stats to their actual metric names.
    sig { returns(T::Hash[Symbol, String]) }
    def coverage_stats
      {
        total_signatures: "ruby_typer.unknown..types.sig.count",
        total_methods: "ruby_typer.unknown..types.input.methods.total",
        total_classes: "ruby_typer.unknown..types.input.classes.total"
      }
    end

    # Mapping of sigil stats to their actual metric names.
    sig { returns(T::Hash[Symbol, String]) }
    def sigil_breakdown_stats
      {
        total_files: "ruby_typer.unknown..types.input.files",
        sigil_ignore: "ruby_typer.unknown..types.input.files.sigil.ignore",
        sigil_false: "ruby_typer.unknown..types.input.files.sigil.false",
        sigil_true: "ruby_typer.unknown..types.input.files.sigil.true",
        sigil_strict: "ruby_typer.unknown..types.input.files.sigil.strict",
        sigil_strong: "ruby_typer.unknown..types.input.files.sigil.strong"
      }
    end

    # Extract the requested metric values.
    sig {
      params(
        requested_stats: T::Hash[Symbol, String],
        metrics: Metrics
      ).returns(T::Hash[Symbol, T.nilable(Integer)])
    }
    def collect_values(requested_stats, metrics)
      result = {}
      requested_stats.map do |label, name|
        result[label] = metrics[name]&.value
      end
      result
    end
  end
end

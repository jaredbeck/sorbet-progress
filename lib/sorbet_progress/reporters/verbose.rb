# typed: strict
# frozen_string_literal: true

module SorbetProgress
  module Reporters
    # The first reporter written. It's quite verbose, so I'm calling it ..
    class Verbose
      extend T::Sig

      sig { params(calculator: Calculator).void }
      def initialize(calculator)
        @calculator = calculator
      end

      sig { returns(String) }
      def report
        [
          "Sorbet Progress\n",
          "Progress for sig coverage",
          coverage_metrics,
          "\nProgress for file coverage",
          sigil_percentages,
          "---------------------------------------",
          "Total: \t\t\t#{@calculator.total}\t100%",
          "Keep up the good work 👍"
        ].flatten.join("\n")
      end

      private

      # Example output:
      #
      # ```
      # total_signatures  7528
      # total_methods     183447
      # total_classes     112433
      # ```
      sig { returns(T::Array[String]) }
      def coverage_metrics
        @calculator.coverage_metrics.map do |label, value|
          format_metric(label, value)
        end
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

      # Example output:
      #
      # ```
      # sigil_ignore   12      0.20 %
      # sigil_false    5466    91.60 %
      # sigil_true     460     7.71 %
      # sigil_strict   12      0.20 %
      # sigil_strong   17      0.28 %
      # ```
      sig { returns(T::Array[String]) }
      def sigil_percentages
        @calculator.sigil_percentages.map do |elem|
          percentage =
            if elem[:percentage]
              elem[:percentage] * 100
            else
              0
            end
          format(
            "%-17s\t%d\t%.2f %%",
            elem[:label],
            elem[:value] || 0,
            percentage
          )
        end
      end
    end
  end
end

# typed: strict
# frozen_string_literal: true

require "rainbow"
require "sorbet_progress/reporters/base"

module SorbetProgress
  module Reporters
    # Produces output something like this:
    #
    # ```
    # Sorbet progress: ignore | false | true | strict+
    # |----------------50--------------|---------25--------|-5-|------20------|
    # Keep up the good work 👍
    # ```
    #
    # The chart is colored. Colorless terminals are not supported.
    #
    # Strict and strong are combined into one category because strong is not
    # a reachable goal in most projects.
    class BarChart < Base
      extend T::Sig

      COLORS = T.let(%w[red yellow green blue].freeze, T::Array[String])
      LENGTH = 80

      sig { params(calculator: Calculator).void }
      def initialize(calculator)
        @calculator = calculator
      end

      sig { override.returns(String) }
      def report
        [
          "Sorbet progress: ignore | false | true | strict+",
          bar_chart,
          "Keep up the good work 👍"
        ].flatten.join("\n")
      end

      private

      sig { returns(String) }
      def bar_chart
        body = segments.each_with_index.each_with_object([]) { |(e, i), a|
          a.push(segment(e, i))
        }.join("|")
        format("|%s|", body)
      end

      sig { params(fraction: Float, index: Integer).returns(String) }
      def segment(fraction, index)
        padding_max = (fraction * LENGTH / 2).round
        padding_length = [1, padding_max].max
        pad = "-" * padding_length
        Rainbow(
          format("%s%d%s", pad, fraction * 100, pad)
        ).send(T.must(COLORS[index]))
      end

      sig { returns(T::Array[Float]) }
      def segments
        sigils = sigil_count_by_name
        [
          T.let(sigils.fetch(:sigil_ignore, 0.0), Float),
          T.let(sigils.fetch(:sigil_false, 0.0), Float),
          T.let(sigils.fetch(:sigil_true, 0.0), Float),
          T.let(
            sigils.fetch(:sigil_strict, 0.0) + sigils.fetch(:sigil_strong, 0.0),
            Float
          )
        ]
      end

      sig { returns(T::Hash[Symbol, Float]) }
      def sigil_count_by_name
        @calculator.sigil_percentages.each_with_object({}) { |e, a|
          a[e.fetch(:label)] = e.fetch(:percentage, 0.0).to_f
        }
      end
    end
  end
end

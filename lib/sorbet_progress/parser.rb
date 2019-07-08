# frozen_string_literal: true

# typed: strict

require "json"
require "sorbet_progress/error"
require "sorbet_progress/metric"
require "sorbet_progress/metrics"

module SorbetProgress
  # Parse Sorbet's JSON metrics file.
  class Parser
    extend T::Sig

    sig { params(json: String).returns(Metrics) }
    def parse(json)
      transform(parse_json(json))
    end

    private

    sig { params(json: String).returns(Hash) }
    def parse_json(json)
      JSON.parse(json)
    rescue JSON::ParserError => e
      raise Error.new(3, "Metrics file is not valid JSON: " + e.message)
    end

    sig { params(parsed: Hash).returns(Metrics) }
    def transform(parsed)
      Metrics.new(
        parsed.
          fetch("metrics").
          map { |metric|
            next unless metric.key?("value")
            Metric.new(
              metric.fetch("name"),
              metric.fetch("value")
            )
          }.
          compact
      )
    rescue KeyError => e
      raise Error.new(4, "Expected file to have key: metrics: " + e.message)
    end
  end
end

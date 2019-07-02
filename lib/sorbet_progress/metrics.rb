# typed: true
# frozen_string_literal: true

require "sorbet_progress/error"
require "sorbet_progress/metric"

module SorbetProgress
  # A collection of `Metric`s. Acts like a Hash, though sorbet actually gives
  # us an array.
  class Metrics
    extend T::Sig

    sig { params(array: T::Array[Metric]).void }
    def initialize(array)
      @array = array
    end

    sig { params(name: String).returns(T.nilable(Metric)) }
    def [](name)
      @array.find { |metric| metric.name == name }
    end

    sig { params(name: String).returns(Metric) }
    def fetch(name)
      result = @array.find { |metric| metric.name == name }
      if result.nil?
        raise Error.new(5, "Metric not found: " + name)
      else
        result
      end
    end
  end
end

# typed: true
# frozen_string_literal: true

module SorbetProgress
  # Just a simple key-value pair, though sorbet could decide to do something
  # more complicated in the future.
  class Metric
    extend T::Sig

    attr_reader :name, :value

    sig { params(name: String, value: Integer).void }
    def initialize(name, value)
      @name = name
      @value = value
    end
  end
end

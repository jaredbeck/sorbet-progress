# typed: strict
# frozen_string_literal: true

module SorbetProgress
  # Parent class of all errors raised by SorbetProgress.
  # Every error should have a unique number.
  class Error < StandardError
    extend T::Sig

    sig { params(number: Integer, message: String).void }
    def initialize(number, message)
      super(
        format(
          "%s (SPE%d)",
          message,
          number
        )
      )
    end
  end
end

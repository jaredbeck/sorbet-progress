# typed: strict
# frozen_string_literal: true

require "rainbow"

module SorbetProgress
  module Reporters
    # Abstract
    class Base
      extend T::Helpers
      extend T::Sig
      abstract!

      sig { params(calculator: Calculator).void }
      def initialize(calculator)
        @calculator = calculator
      end

      sig { abstract.returns(String) }
      def report
      end
    end
  end
end

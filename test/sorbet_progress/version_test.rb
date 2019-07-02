require "test_helper"

module SorbetProgress
  class VersionTest < Minitest::Test
    def test_that_it_has_a_version_number
      assert ::SorbetProgress.gem_version.is_a?(::Gem::Version)
    end
  end
end

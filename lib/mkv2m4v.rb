require "mkv2m4v/version"
require "trollop"

module Mkv2m4v
  class Command
    def initialize
      parse_options
    end

    def convert
    end

    private

    def parse_options
      @options = Trollop::options do
        version Mkv2m4v::VersionDescription
        banner Mkv2m4v::Description
      end
    end
  end
end

require "mkv2m4v/version"
require "mkv2m4v/file"
require "trollop"

module Mkv2m4v
  class Command
    def initialize
      parse_options
    end

    def run
      if @options[:info]
        print_info
      else
        convert_files
      end
    end

    private

    def convert_files
      $stderr.puts "Converting files is not yet supported. For now, try the --info option."
    end

    def print_info
      each_file(&:print)
    end

    def each_file
      Mkv2m4v::File.each(@filenames) do |file|
        yield file
      end
    end

    def parse_options
      usage = usage
      @options = Trollop::options do
        version Mkv2m4v::VersionDescription
        banner [Mkv2m4v::Description, Mkv2m4v::Usage].join("\n")
        opt :info, "Print media info only"
      end
      @filenames = ARGV
    end
  end
end

require "mkv2m4v/version"
require "mkv2m4v/file"
require "trollop"
require "colorize"

module Mkv2m4v
  class Command
    def initialize
      parse_options
    end

    def run
      if @options[:info]
        each_file(&:print_info)
      else
        each_file(&:transcode)
      end
    end

    private

    def each_file
      Mkv2m4v::File.each(@filenames, @options) do |file|
        yield file
      end
    end

    def parse_options
      parser = Trollop::Parser.new do
        version Mkv2m4v::VersionDescription
        banner [Mkv2m4v::Description, Mkv2m4v::Usage].join("\n")
        opt :info,  "Print media info only"
        opt :lang,  "Preferred languages, comma separated", :type => :string, :default => "English"
        opt :dir,   "Destination directory (default: same dir as source mkv)", :type => :string
        opt :check, "Check dependencies"
      end
      @options = Trollop::with_standard_exception_handling(parser) { parser.parse ARGV }
      parse_languages
      @filenames = ARGV


      check_dependencies_and_exit if @options[:check]
      parser.educate if @filenames.empty?
    end

    def parse_languages
      @options[:languages] =
        @options[:lang].split(/\s*,\s*/).map { |lang| Iso639[lang] }.compact
    end

    def check_dependencies_and_exit
      results = []
      results << check_dependency("mediainfo",  "--Version", "media-info", :exit_status => 255)
      results << check_dependency("MP4Box",     "-version",  "gpac")
      results << check_dependency("mkvextract", "--version", "mkvtoolnix", :requirements => "version >= 6 required")
      results << check_dependency("ffmpeg",     "-version",  "ffmpeg --with-tools")
      exit results.count(false)
    end

    def check_dependency(command, version_arg, brew_arg, options = {})
      requirements = options.delete(:requirements)
      exit_status  = options.delete(:exit_status)

      puts "Checking #{command}...".magenta
      success = system(command, version_arg) || $?.exitstatus == exit_status
      if success
        print "  ...Installed. ".green
        puts requirements.to_s.yellow.on_black
      else
        $stderr.puts "Missing #{command}. Please `brew install #{brew_arg}`".white.on_red
      end
      success
    end
  end
end

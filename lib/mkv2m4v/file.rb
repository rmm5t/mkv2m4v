require "mediainfo"
require "forwardable"
require "mkv2m4v/track"
require "mkv2m4v/language_codes"

module Mkv2m4v
  class File
    extend Forwardable

    attr_reader :info, :video_tracks, :audio_tracks, :text_tracks
    def_delegator :info, :filename, :name

    def initialize(filename, options = {})
      @info = Mediainfo.new(filename)
      @options = options
      @language_code = LanguageCodes[@options[:lang]]
      init_tracks
    end

    def format
      info.general.format
    end

    def print
      puts "#{format}: #{name}"
      video_tracks.each(&:print)
      audio_tracks.each(&:print)
      text_tracks.each(&:print)
      puts
    end

    def self.each(filenames, options = {})
      filenames.each do |filename|
        if ::File.exists?(filename)
          yield new(filename, options)
        else
          $stderr.puts "#{filename} does not exist."
        end
      end
    end

    private

    def init_tracks
      @video_tracks = tracks_by_type(:video)
      @audio_tracks = tracks_by_type(:audio)
      @text_tracks  = tracks_by_type(:text)
    end

    def tracks_by_type(type)
      tracks = info.send(type)
      tracks.count.times.map do |i|
        Mkv2m4v.const_get("#{type.capitalize}Track").new(tracks[i])
      end.select { |track| track.matches_language?(@language_code) }
    end
  end
end

require "mkv2m4v/track"
require "mkv2m4v/track_ranker"
require "mkv2m4v/transcoder"
require "mediainfo"
require "forwardable"
require "iso639"
require "colorize"

module Mkv2m4v
  class File
    extend Forwardable

    attr_reader :info, :video_tracks, :audio_tracks, :text_tracks
    attr_reader :info, :filtered_video_tracks, :filtered_audio_tracks, :filtered_text_tracks
    attr_reader :ideal_video_track, :ideal_audio_track, :ideal_text_track
    def_delegator :info, :filename, :name
    def_delegator :info, :full_filename, :filename

    def initialize(filename, options = {})
      @info = Mediainfo.new(filename)
      @options = options
      @languages = @options[:languages]
      init_tracks
    end

    def format
      info.general.format
    end

    def print_info
      process do
        print_filtered_tracks
      end
    end

    def transcode
      process do
        print_ideal_tracks
        Transcoder.new(self, @options).run
      end
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

    def process
      preamble
      yield
      postamble
    end

    def preamble
      print "#{format}: #{name}".black.on_yellow
      langs = @languages.empty? ? "all languages" : @languages.join(", ")
      puts " (matching #{langs})".yellow.on_black
    end

    def postamble
      puts
    end

    def print_all_tracks
      video_tracks.each(&:print)
      audio_tracks.each(&:print)
      text_tracks.each(&:print)
    end

    HIGHLIGHT_COLOR = { :background => :cyan }

    def print_filtered_tracks
      filtered_video_tracks.each do |t|
        t.print t == ideal_video_track && HIGHLIGHT_COLOR
      end
      filtered_audio_tracks.each do |t|
        t.print t == ideal_audio_track && HIGHLIGHT_COLOR
      end
      filtered_text_tracks.each do |t|
        t.print t == ideal_text_track && HIGHLIGHT_COLOR
      end
    end

    def print_ideal_tracks
      ideal_video_track.print HIGHLIGHT_COLOR
      ideal_audio_track.print HIGHLIGHT_COLOR
    end

    def init_tracks
      @video_tracks = tracks_by_type(:video).rank
      @audio_tracks = tracks_by_type(:audio).rank
      @text_tracks  = tracks_by_type(:text).rank

      @filtered_video_tracks = video_tracks.filter
      @filtered_audio_tracks = audio_tracks.filter
      @filtered_text_tracks  = text_tracks.filter

      @ideal_video_track = filtered_video_tracks.first
      @ideal_audio_track = filtered_audio_tracks.first
      @ideal_text_track  = filtered_text_tracks.first
    end

    def tracks_by_type(type)
      info_tracks = info.send(type)
      tracks = info_tracks.count.times.map do |i|
        Mkv2m4v.const_get("#{type.to_s.capitalize}Track").new(info_tracks[i])
      end
      Mkv2m4v.const_get("#{type.to_s.capitalize}Ranker").new(tracks, @options)
    end
  end
end

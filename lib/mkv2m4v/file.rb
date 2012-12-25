require "mkv2m4v/track"
require "mkv2m4v/track_ranker"
require "mkv2m4v/transcoder"
require "mediainfo"
require "forwardable"
require "iso639"

module Mkv2m4v
  class File
    extend Forwardable

    attr_reader :info, :video_tracks, :audio_tracks, :text_tracks
    attr_reader :ideal_video_track, :ideal_audio_track
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

    def print
      puts "#{format}: #{name}"
      video_tracks.filter.each(&:print) if @options[:verbose]
      audio_tracks.filter.each(&:print) if @options[:verbose]
      text_tracks.filter.each(&:print)  if @options[:verbose]
      print_ideal_tracks
      puts
    end

    def transcode
      puts "#{format}: #{name}"
      Transcoder.new(self, @options).run
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

    def print_ideal_tracks
      puts "==> Ideal video track"
      @ideal_video_track.print
      puts "==> Ideal audio track"
      @ideal_audio_track.print
    end

    def init_tracks
      @video_tracks = tracks_by_type(:video)
      @audio_tracks = tracks_by_type(:audio)
      @text_tracks  = tracks_by_type(:text)

      @ideal_video_track = video_tracks.filter.rank.first
      @ideal_audio_track = audio_tracks.filter.rank.first
    end

    def tracks_by_type(type)
      info_tracks = info.send(type)
      tracks = info_tracks.count.times.map do |i|
        Mkv2m4v.const_get("#{type.capitalize}Track").new(info_tracks[i])
      end
      Mkv2m4v.const_get("#{type.capitalize}Ranker").new(tracks, @options)
    end
  end
end

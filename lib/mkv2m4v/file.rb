require "mediainfo"
require "forwardable"
require "mkv2m4v/track"

module Mkv2m4v
  class File
    extend Forwardable

    attr_reader :info, :video_tracks, :audio_tracks, :text_tracks
    def_delegator :info, :filename, :name

    def initialize(filename)
      @info = Mediainfo.new(filename)
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

    def self.each(filenames)
      filenames.each do |filename|
        if ::File.exists?(filename)
          yield new(filename)
        else
          $stderr.puts "#{filename} does not exist."
        end
      end
    end

    private

    def init_tracks
      init_video_tracks
      init_audio_tracks
      init_text_tracks
    end

    def init_video_tracks
      @video_tracks = info.video.count.times.map do |i|
        VideoTrack.new(info.video[i])
      end
    end

    def init_audio_tracks
      @audio_tracks = info.audio.count.times.map do |i|
        AudioTrack.new(info.audio[i])
      end
    end

    def init_text_tracks
      @text_tracks = info.text.count.times.map do |i|
        TextTrack.new(info.text[i])
      end
    end
  end
end

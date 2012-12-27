require "forwardable"

module Mkv2m4v
  class Track
    extend Forwardable

    attr_reader :info
    def_delegator :info, :stream_id, :id
    def_delegators :info, :format

    def initialize(track_info)
      @info = track_info
    end

    def language
      Iso639[info["language"]]
    end

    def title
      info["title"]
    end

    def format_description
      "#{format} (#{info.format_info}, #{info.codec_id})"
    end
  end

  class VideoTrack < Track
    def_delegators :info, :frame_size, :interlaced?, :fps, :width, :height

    def resolution
      "#{frame_size}#{interlaced? ? "i" : "p"}"
    end

    def print(color = nil)
      puts "Video Track ##{id}:".colorize(color)
      puts "  Format:     #{format_description}"
      puts "  Resolution: #{resolution}"
      puts "  FPS:        #{fps}"
      puts "  Language:   #{language}"
      puts "  Title:      #{title}"
    end
  end

  class AudioTrack < Track
    def_delegators :info, :bit_rate

    def channel_count
      info.channels.to_s.chars.first.to_i
    end

    def bit_rate_kbps
      info.bit_rate.gsub(/\D/, "").to_i if info.bit_rate
    end

    def channel_description
      "#{channel_count} (#{info.channel_positions})"
    end

    def bit_rate_description
      "#{bit_rate_kbps}k (#{info.bit_rate_mode})"
    end

    def print(color = nil)
      puts "Audio Track ##{id}:".colorize(color)
      puts "  Format:     #{format_description}"
      puts "  Channels:   #{channel_description}"
      puts "  Bit rate:   #{bit_rate_description}"
      puts "  Language:   #{language}"
      puts "  Title:      #{title}"
    end
  end

  class TextTrack < Track
    def format_description
      "#{format} (#{info.codec_id})"
    end

    def print(color = nil)
      puts "Text Track ##{id}:".colorize(color)
      puts "  Format:     #{format_description}"
      puts "  Language:   #{language}"
      puts "  Title:      #{title}"
    end
  end
end

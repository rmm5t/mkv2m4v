require "forwardable"

module Mkv2m4v
  class TrackRanker
    extend Forwardable

    def_delegators :@tracks, :each, :first

    def initialize(tracks, options = {})
      @tracks = tracks
      @options = options
    end

    def filter
      filtered_tracks = @tracks.select { |t| language_okay?(t) }
      self.class.new(filtered_tracks, @options)
    end

    def rank
      ranked_tracks = @tracks.sort_by { |t| score(t) }.reverse
      self.class.new(ranked_tracks, @options)
    end

    protected

    def language_match?(track)
      @options.languages.include?(track.language)
    end

    def language_okay?(track)
      track.language.nil? ||
        @options.languages.empty? ||
        language_match?(track)
    end
  end

  class VideoRanker < TrackRanker
    def score(track)
      score = 0
      score += 8 if track.format == "AVC"
      score += (track.height || 0)/ 1080.0 * 4.0
      score += 2 if language_match?(track)
      score
    end
  end

  class AudioRanker < TrackRanker
    def score(track)
      score = 0
      score += 4 if ["DTS", "AC-3"].include?(track.format)
      score += 2 if track.format == "AAC"
      score += (track.channel_count || 0) / 8.0 * 2.0
      score += (track.bit_rate_kbps || 0) / 1500.0 * 2.0
      score += 4 if language_match?(track)
      score
    end
  end

  class TextRanker < TrackRanker
    def score(track)
      score = 0
      score += 3 if track == first
      score += 4 if language_match?(track)
      score
    end
  end
end

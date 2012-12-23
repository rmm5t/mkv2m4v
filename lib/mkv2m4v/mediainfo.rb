require "mediainfo"

class Mediainfo::Stream
  def language
    self["language"]
  end
end

class Mediainfo::AudioStream
  def channel_count
    channels.to_s.chars.first.to_i
  end
end

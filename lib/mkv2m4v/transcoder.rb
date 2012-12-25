module Mkv2m4v
  class Transcoder
    def initialize(file, options = {})
      @file = file
      @options = options
    end

    def run
      setup
      extract
      transcode_avc
      transcode_aac
      transcode_ac3
      remux
      cleanup
    end

    private

    def setup
      FileUtils.mkdir_p tmp_dir
    end

    def extract
      puts "==> Extracting #{video_id}:video.#{video_ext} #{audio_id}:audio.#{audio_ext} "
      system "mkvextract tracks #{@file.filename.inspect} #{video_id}:#{video_file} #{audio_id}:#{audio_file}"
    end

    def transcode_avc
      if video_format == "AVC"
        puts "==> Assuming pass through for h.264 video track"
      else
        puts "==> ERROR: Wrong Video format"
      end
    end

    def transcode_aac
      if audio_format == "AAC"
        puts "==> Assuming pass through for AAC audio track"
      else
        puts "==> Transcoding #{audio_format} to Stereo AAC audio track"
        system "ffmpeg -i #{audio_file.inspect} -acodec libfaac -ac 2 -ab 160k #{audio_basename}.aac"
      end
    end

    def transcode_ac3
      if audio_format == "AC-3"
        puts "==> Assuming pass through for AC-3 audio track"
      elsif audio_format == "AAC"
        puts "==> Skipping AC-3 surround audio track"
        @skip_ac3 = true
      else
        puts "==> Transcoding #{audio_format} to Aurround AC-3 audio track"
        system "ffmpeg -i #{audio_file.inspect} -acodec ac3 -ac #{max_audio_channels} -ab #{max_audio_bit_rate}k #{audio_basename}.ac3"
      end
    end

    def remux
      puts "==> Remuxing everything into an M4V container (#{m4v_file})"
      command = "MP4Box"
      command << " -add #{video_basename.inspect}.h264:lang=en:name=\"AVC Video\" "
      command << " -add #{audio_basename.inspect}.aac:lang=en:group=1:delay=84:name=\"Stereo\" "
      unless @skip_ac3
        command << " -add #{audio_basename.inspect}.ac3:lang=en:group=1:delay=84:disable:name=\"AC3\" "
      end
      command << " -new #{m4v_file.inspect}"
      system command
    end

    def cleanup
      FileUtils.rm_rf tmp_dir
    end

    def video_basename
      ::File.join(tmp_dir, "video")
    end

    def video_file
      [video_basename, video_ext].join(".")
    end

    def video_id
      @file.ideal_video_track.id
    end

    def video_format
      @file.ideal_video_track.format
    end

    def video_ext
      if video_format == "AVC"
        "h264"
      else
        video_format.gsub(/\W/, "").downcase
      end
    end

    def audio_basename
      ::File.join(tmp_dir, "audio")
    end

    def audio_file
      [audio_basename, audio_ext].join(".")
    end

    def audio_id
      @file.ideal_audio_track.id
    end

    def audio_format
      @file.ideal_audio_track.format
    end

    def audio_ext
      audio_format.gsub(/\W/, "").downcase
    end

    def max_audio_channels
      [@file.ideal_audio_track.channel_count, 6].min
    end

    def max_audio_bit_rate
      [@file.ideal_audio_track.bit_rate_kbps, 640].min
    end

    def dir
      @options[:dir] || ::File.dirname(@file.filename)
    end

    def tmp_dir
      ::File.join(dir, ::File.basename(@file.name, ".*") + "-tracks")
    end

    def m4v_file
      ::File.join(dir, ::File.basename(@file.name, ".*") + ".m4v")
    end
  end
end

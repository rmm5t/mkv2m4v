require "fileutils"
require "colorize"
require "shellwords"
require "iso639/language"

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
      puts "==> Extracting #{video_id}:video.#{video_ext} #{audio_id}:audio.#{audio_ext} ".magenta
      command = "mkvextract tracks"
      command << " #{escape(@file.filename)}"
      command << " #{video_id}:#{escape(video_file)}"
      command << " #{audio_id}:#{escape(audio_file)}"
      sh command
    end

    def transcode_avc
      if video_format == "AVC"
        puts "==> Assuming pass through for h.264 video track".yellow.on_black
      else
        puts "==> ERROR: Wrong Video format".white.on_red
      end
    end

    def transcode_aac
      if audio_format == "AAC"
        puts "==> Assuming pass through for AAC audio track".yellow.on_black
      else
        puts "==> Transcoding #{audio_format} to Stereo AAC audio track".magenta
        command = "ffmpeg"
        command << " -i #{escape(audio_file)}"
        command << " -acodec libfaac -ac 2 -ab 160k"
        command << " #{escape(audio_basename)}.aac"
        sh command
      end
    end

    def transcode_ac3
      if audio_format == "AC-3"
        puts "==> Assuming pass through for AC-3 audio track".yellow.on_black
      elsif audio_format == "AAC"
        puts "==> Skipping AC-3 surround audio track".yellow.on_black
        @skip_ac3 = true
      else
        puts "==> Transcoding #{audio_format} to Surround AC-3 audio track".magenta
        command = "ffmpeg"
        command << " -i #{escape(audio_file)}"
        command << " -acodec ac3 -ac #{max_audio_channels} -ab #{max_audio_bit_rate}k"
        command << " #{escape(audio_basename)}.ac3"
        sh command
      end
    end

    def remux
      puts "==> Remuxing everything into an M4V container".magenta
      command = "MP4Box"
      command << " -add #{escape(video_basename)}.h264:lang=#{video_language.alpha3_terminology}:name=\"AVC Video\""
      command << " -add #{escape(audio_basename)}.aac:lang=#{audio_language.alpha3_terminology}:group=1:delay=84:name=\"Stereo\""
      unless @skip_ac3
        command << " -add #{escape(audio_basename)}.ac3:lang=#{audio_language.alpha3_terminology}:group=1:delay=84:disable:name=\"AC3\" "
      end
      command << " -new #{escape(m4v_file)}"
      sh command
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

    def video_language
      @file.ideal_video_track.language || @options[:languages].first || UnknownLanguage
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

    def audio_language
      @file.ideal_audio_track.language || @options[:languages].first || UnknownLanguage
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

    def escape(str)
      Shellwords.escape(str)
    end

    def sh(command)
      puts command
      system command
    end

    UnknownLanguage = Iso639::Language.new("", "", "", "", "")
  end
end

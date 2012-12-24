require "iso-639"

module Mkv2m4v
  LanguageCodes = Hash.new

  def LanguageCodes.[](key)
    key.respond_to?(:downcase) ? super(key.downcase) : super(key)
  end

  def LanguageCodes.[]=(key, value)
    key.respond_to?(:downcase) ? super(key.downcase, value) : super(key, value)
  end

  ISO_639::ISO_639_1.each do |lang|
    LanguageCodes[lang.alpha2] = lang.alpha2
    LanguageCodes[lang.alpha3] = lang.alpha2
    lang.english_name.split(/[,;]\s*/).each do |name|
      LanguageCodes[name] = lang.alpha2
    end
  end
end

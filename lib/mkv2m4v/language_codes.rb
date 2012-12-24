require "iso-639"

module Mkv2m4v
  LanguageCodes = Hash.new

  def LanguageCodes.[](key)
    super(key.to_s.strip.downcase)
  end

  def LanguageCodes.[]=(key, value)
    super(key.to_s.strip.downcase, value)
  end

  ISO_639::ISO_639_1.each do |lang|
    LanguageCodes[lang.alpha2] = lang.alpha3
    LanguageCodes[lang.alpha3] = lang.alpha3
    LanguageCodes[lang.alpha3_terminologic] = lang.alpha3
    lang.english_name.split(/;\s*/).each do |name|
      LanguageCodes[name] = lang.alpha3
    end
  end
end

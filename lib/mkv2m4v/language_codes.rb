require "iso-639"

module Mkv2m4v
  LanguageCodes = Hash.new
  ISO_639::ISO_639_1.each do |lang|
    LanguageCodes[lang.alpha2] = lang.alpha2
    LanguageCodes[lang.alpha3] = lang.alpha2
    lang.english_name.split(/[,;]\s*/).each do |name|
      LanguageCodes[name] = lang.alpha2
    end
  end
end

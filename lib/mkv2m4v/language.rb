require "iso-639"

module Mkv2m4v
  module Language
    def self.find(lang)
      language = if lang.length < 4
                   ISO_639.find_by_code(lang)
                 else
                   ISO_639.find_by_english_name(lang.capitalize)
                 end
      language.alpha2 if language
    end
  end
end

require "test_helper"
require "mkv2m4v/language_codes"

describe Mkv2m4v::LanguageCodes do
  it "should respond to 2-letter ISO-639-1 codes" do
    assert_equal "eng", Mkv2m4v::LanguageCodes["en"]
    assert_equal "spa", Mkv2m4v::LanguageCodes["es"]
    assert_equal "fre", Mkv2m4v::LanguageCodes["fr"]
    assert_equal "ger", Mkv2m4v::LanguageCodes["de"]
    assert_equal "dut", Mkv2m4v::LanguageCodes["nl"]
  end

  it "should respond to 3-letter ISO-639-2 (bibliographic) codes" do
    assert_equal "eng", Mkv2m4v::LanguageCodes["eng"]
    assert_equal "spa", Mkv2m4v::LanguageCodes["spa"]
    assert_equal "fre", Mkv2m4v::LanguageCodes["fre"]
    assert_equal "ger", Mkv2m4v::LanguageCodes["ger"]
    assert_equal "dut", Mkv2m4v::LanguageCodes["dut"]
    assert_equal "pol", Mkv2m4v::LanguageCodes["pol"]
  end

  it "should respond to 3-letter ISO-639-2 (terminologic) codes" do
    assert_equal "fre", Mkv2m4v::LanguageCodes["fra"]
    assert_equal "ger", Mkv2m4v::LanguageCodes["deu"]
    assert_equal "dut", Mkv2m4v::LanguageCodes["nld"]
  end

  it "should respond to english language name" do
    assert_equal "eng", Mkv2m4v::LanguageCodes["English"]
    assert_equal "spa", Mkv2m4v::LanguageCodes["Spanish"]
    assert_equal "fre", Mkv2m4v::LanguageCodes["French"]
    assert_equal "ger", Mkv2m4v::LanguageCodes["German"]
    assert_equal "dut", Mkv2m4v::LanguageCodes["Dutch"]
    assert_equal "pol",  Mkv2m4v::LanguageCodes["Polish"]
  end

  it "should respond to any case" do
    assert_equal "eng", Mkv2m4v::LanguageCodes["EN"]
    assert_equal "spa", Mkv2m4v::LanguageCodes["eS"]
    assert_equal "fre", Mkv2m4v::LanguageCodes["Fre"]
    assert_equal "ger", Mkv2m4v::LanguageCodes["GeRmAn"]
    assert_equal "dut", Mkv2m4v::LanguageCodes["DuTCH"]
  end

  it "should ignore whitespace" do
    assert_equal "eng", Mkv2m4v::LanguageCodes[" EN"]
    assert_equal "spa", Mkv2m4v::LanguageCodes["eS "]
    assert_equal "fre", Mkv2m4v::LanguageCodes["\tFre\t"]
  end
end

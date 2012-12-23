module Mkv2m4v
  VERSION = "0.0.1"

  VersionDescription = "mkv2m4v #{VERSION} (c) 2012 Ryan McGeary"
  Description = <<EOS
mkv2m4v is a command line utility that converts audio and video tracks from a
MKV (Matroska Media Container) container into a format compatible with Apple
TVs.
EOS
  Usage = <<EOS
Usage:
  mkv2m4v [options] <filenames>+

Options:
EOS
end

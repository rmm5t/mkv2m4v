require "minitest/autorun"
require "minitest/emoji"

# Borrowed from https://gist.github.com/4369168
MiniTest::Emoji::DEFAULT.merge!(
  '.' => "\u{1f49A} ",
  'F' => "\u{1f494} ",
  'E' => "\u{1f480} ",
  'S' => "\u{1f49B} "
)

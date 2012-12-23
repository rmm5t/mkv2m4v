# mkv2m4v

Converts audio and video tracks from a MKV (Matroska Media Container)
container into a format compatible with Apple TVs.

It will attempt to pass thru as many codecs as possible.

* It assumes that the video track is already in H264.
* It will convert a DTS audio track into separate AAC and AC3 tracks.
* If no DTS, it will pass thru the original AAC and AC3 tracks.

## Installation

Add this line to your application's Gemfile:

    $ gem install mkv2m4v

## Usage

    $ mkv2m4v some-video.mkv

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

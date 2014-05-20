# mkv2m4v [![Gem Version](http://img.shields.io/gem/v/mkv2m4v.svg)](https://rubygems.org/gems/mkv2m4v) [![Code Climate](http://img.shields.io/codeclimate/github/rmm5t/mkv2m4v.svg)](https://codeclimate.com/github/rmm5t/mkv2m4v)

Converts audio and video tracks from a MKV (Matroska Media) container into a
format compatible with Apple TVs.

It attempts to pass through as many codecs as possible.

* It assumes that the video track is already in H.264/MPEG-4 (Advanced Video
  Codec).
* It will convert a DTS audio track into separate AAC and AC3 tracks.
* If no DTS, it will pass through the original AAC and/or AC3 tracks.

## How You Can Help

**If you like this project, please help. [Donate via Gittip][gittip] or [buy me a coffee with Bitcoin][bitcoin].**<br>
[![Gittip](http://img.shields.io/gittip/rmm5t.svg)][gittip]
[![Bitcoin](http://img.shields.io/badge/bitcoin-buy%20me%20a%20coffee-brightgreen.svg)][bitcoin]

**[Bitcoin][bitcoin]**: `1rmm5tv6f997JK5bLcGbRCZyVjZUPkQ2m`<br>
[![Bitcoin Donation][bitcoin-qr-small]][bitcoin-qr-big]

## Need Help?

**You can [book a session with me on Codementor][codementor].**<br>
[![Book a Codementor session](http://img.shields.io/badge/codementor-book%20a%20session-orange.svg)][codementor]

[gittip]: https://www.gittip.com/rmm5t/ "Donate to rmm5t for open source!"
[bitcoin]: https://blockchain.info/address/1rmm5tv6f997JK5bLcGbRCZyVjZUPkQ2m "Buy rmm5t a coffee for open source!"
[bitcoin-scheme]: bitcoin:1rmm5tv6f997JK5bLcGbRCZyVjZUPkQ2m?amount=0.01&label=Coffee%20to%20rmm5t%20for%20Open%20Source "Buy rmm5t a coffee for open source!"
[bitcoin-qr-small]: http://chart.apis.google.com/chart?cht=qr&chs=150x150&chl=bitcoin%3A1rmm5tv6f997JK5bLcGbRCZyVjZUPkQ2m%3Famount%3D0.01%26label%3DCoffee%2520to%2520rmm5t%2520for%2520Open%2520Source
[bitcoin-qr-big]: http://chart.apis.google.com/chart?cht=qr&chs=500x500&chl=bitcoin%3A1rmm5tv6f997JK5bLcGbRCZyVjZUPkQ2m%3Famount%3D0.01%26label%3DCoffee%2520to%2520rmm5t%2520for%2520Open%2520Source
[codementor]: https://www.codementor.io/rmm5t?utm_campaign=profile&utm_source=button-rmm5t&utm_medium=shields "Book a session with rmm5t on Codementor!"

## Installation

mkv2m4v is dependent upon `mediainfo`, `mkvextract`, `ffmpeg`, and `MP4Box`.

```bash
$ brew install mediainfo
$ brew install gpac
$ brew install mkvtoolnix # version >= 6 required
$ gem install mkv2m4v
```

_Note: `gpac` includes `MP4Box` and is dependent on `ffmpeg`, so `ffmpeg`
should install automatically. If not, you should manually install `ffmpeg`:_

```bash
# ffmpeg should already be installed, but just in case:
$ brew install ffmpeg --with-tools
```

If you have any trouble after installing the mkdv2m4v gem, you can test the
dependencies using the `--check` argument:

```bash
$ mkv2m4v --check
```

## Usage

```bash
$ mkv2m4v some-video.mkv
```

## Background

I got fed up with the reliability of the conversion tools out there for
converting MKV video containers to Apple TV compatible videos. Many of the
existing tools appear to have potential on the surface, but they fail under
certain scenarios.

[Handbrake](http://handbrake.fr/) is still the most realiable existing tool
out there, but it re-encodes h.264 video tracks, which is not ideal and very
slow.

The goal is to get a better, more automated tool to accomplish the task of
generating Apple TV compatible videos. Nothing more. It should generate an M4V
media file with the best possible quality given the original source and the
defaults should require no additional human interaction.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

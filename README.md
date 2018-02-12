# mkv2m4v

[![Gem Version](http://img.shields.io/gem/v/mkv2m4v.svg)](https://rubygems.org/gems/mkv2m4v)
[![Maintainability](https://api.codeclimate.com/v1/badges/ad9bc0afa9d14818df50/maintainability)](https://codeclimate.com/github/rmm5t/mkv2m4v/maintainability)
[![Gem Downloads](https://img.shields.io/gem/dt/mkv2m4v.svg)](https://rubygems.org/gems/mkv2m4v)

Converts audio and video tracks from a MKV (Matroska Media) container into a
format compatible with Apple TVs.

It attempts to pass through as many codecs as possible.

* It assumes that the video track is already in H.264/MPEG-4 (Advanced Video
  Codec).
* It will convert a DTS audio track into separate AAC and AC3 tracks.
* If no DTS, it will pass through the original AAC and/or AC3 tracks.

---

**How You Can Help**

[![Square Cash](http://img.shields.io/badge/square%20cash-$rmm5t-brightgreen.svg)][square]
[![PayPal](http://img.shields.io/badge/paypal-rmm5t-blue.svg)][paypal]
[![Book a Codementor session](http://img.shields.io/badge/codementor-book%20a%20session-orange.svg)][codementor]

If you like this project, [buy me a coffee][paypal], or [book a session with me][codementor], or donate bitcoin: `1rmm5tv6f997JK5bLcGbRCZyVjZUPkQ2m`

[square]: https://cash.me/$rmm5t/5 "Donate to rmm5t for open source!"
[paypal]: https://www.paypal.me/rmm5t/5 "Donate to rmm5t for open source!"
[bitcoin]: bitcoin:1rmm5tv6f997JK5bLcGbRCZyVjZUPkQ2m?amount=0.01&label=Coffee%20to%20rmm5t%20for%20Open%20Source "Buy rmm5t a coffee for open source!"
[codementor]: https://www.codementor.io/rmm5t?utm_campaign=profile&utm_source=button-rmm5t&utm_medium=shields "Book a session with rmm5t on Codementor!"

[![Twitter](https://img.shields.io/twitter/follow/rmm5t.svg?style=social)](https://twitter.com/rmm5t)
[![Stack Overflow](https://img.shields.io/stackexchange/stackoverflow/r/8985.svg?style=social)](http://stackoverflow.com/users/8985/ryan-mcgeary)

## Installation

mkv2m4v is dependent upon `mediainfo`, `ffmpeg`, `mkvextract`, and `MP4Box`.

```bash
$ brew install mediainfo
$ brew install ffmpeg --with-tools --with-fdk-aac
$ brew install gpac
$ brew install mkvtoolnix # version >= 6 required
$ gem install mkv2m4v
```

_Note: `gpac` includes `MP4Box`:_

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

## License

[MIT License](https://rmm5t.mit-license.org/)

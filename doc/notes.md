Extracting tracks from an mkv (assuming correct track numbers):

    $ mediainfo example.mkv # Inspect track IDs
    $ mkvextract tracks example.mkv 1:example.h264 2:example.dts

Converting dts to ac3:

    $ ffmpeg -i example.dts -acodec ac3 -ac 6 -ab 640k example-6ch.ac3

Converting dts to aac:

    $ ffmpeg -i example.dts -acodec libfaac -ac 2 -ab 160k example-2ch.aac

Remux the tracks into an M4V container. For Apple TV surround sound support,
the audio tracks must be in the same group with all but the first AAC track
disabled. [[source](http://forum.doom9.org/archive/index.php/t-160302.html)]

    $ MP4Box \
      -add example.h264:lang=en:name="AVC Video" \
      -add example-2ch.aac:lang=en:group=1:name="Stereo" \
      -add example-6ch.ac3:lang=en:group=1:disable:name="AC3" \
      -new example_testing.m4v

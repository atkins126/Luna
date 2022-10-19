You can use FFmpeg to convert movies to MPEG1 format using the .BAT files in
this folder. I've found that a quality setting of -q:v 5 or 6 tends to work
best depending on the video. For example, tinyBigGAMES.mpg worked best with 
5 and Luna.mpg using 6.

1. Download ffmpeg from https://ffmpeg.org/
2. Run mp4-mpeg_qX my_video.mp4
3. It will convert it to a MPEG1 compatible format that can be played back
   in Luna Game Toolkit.
4. You may have to adjust the -q:v setting for optimal playback.
@echo off
ffmpeg -i %1.mp4 -c:v mpeg1video -q:v 6 -c:a mp2 -format mpeg %1.mpg
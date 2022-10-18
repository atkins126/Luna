# CHANGELOG - Luna Game Toolkit

## Version 0.1.0
- [x] Major code refactor
- [x] Added `TLuArchve` and `TLuArchiveFile`. All resources can be loaded from a password protected zip archive.
- [x] Added `TLuEncrypedZipFile` which extends `TZipFile` for password encryption.
- [x] Added `TLuConfigFile` and `TLuStarfield` classes, `BasicStarfield` example
- [x] Added `EntityCollision` example
- [x] Added `TLuPolygon`, `TLuSprite` and `TLuEntity` classes
- [x] Changed the way certain errors are handled in `ApplySettings` method
- [x] If resource file is not found, try to read from filesystem instead
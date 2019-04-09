# Changelog

## 0.11.2-alpha - 2019-04-09

### Changed

- Fixed image scaling so it retains the original image aspect ratio

## 0.11.1-alpha - 2019-04-01

### Changed

- Tweaked the QoS of the artwork queue for better performance

## 0.11.0-alpha - 2019-04-01

### Added

- Display the artwork of the currently playing track underneath the queue

### Changed

- Fix a bug that caused the album view to jump about occasionally
- Fix a bug that caused the incorrect artwork to be displayed for albums that
  have the same name as another album

## 0.10.3a - 2019-03-25

### Changed

- Fixed a bug introduced by the artwork service refactor that missed part of the
  path and thus prevented it loading artwork from the filesystem

## 0.10.2a - 2019-03-23

### Added

- Will fetch album art from the filesystem or MusicBrainz
- Menu option to update the database
- Album art preferences icon

### Changed

- Refactored command queue to be more reliable
- Resizing the windows no longer makes the album view jump around
- Fixed a crash when another client clears the queue

## 0.8.0a - 2019-02-23

### Added

- Connects to MPD
- Lists all albums
- Will play an album
- Queue is working
- Transport controls are working
- Seek bar is working
- Media keys work

# Changelog

## 0.17.0-alpha - 2020-03-08

### Added

- Error handling (it's about time!)
- Shortcut keys for stop, next and previous

### Changed

- Fixes the space bar shortcut key for play/pause not always working
- Fixes text operations in text fields by adding the "Edit" menu back in
- Relayout the preferences window to be more consistent

## 0.16.1-alpha - 2020-02-24

### Fixed

- Bug that prevented albums with different artist and albumartist being enqueued

## 0.16.0-alpha - 2020-02-24

### Changed

- New layout for the queue which includes cover art and song duration
- Treat albums with a zero disc as if they have no disc number
- Fix an occasional launch crashing bug
- Currently playing song cover art now has a black background

## 0.15.0-alpha - 2020-01-31

### Changed

- New layout for the queue which includes cover art and song duration
- Treat albums with a zero disc as if they have no disc number
- Fix an occasional launch crashing bug
- Currently playing song cover art now has a black background

## 0.14.0-alpha - 2020-01-20

### Added

- Adds a search box to the album list view. This enables the filtering of albums.

### Removed

- Option to get album art from MusicBrainz (this should get added back in a future release).
  This is due to a big refactor of the album art fetching system to use Kingfisher instead of my home grown solution.

### Changed

- Fixes a bunch of bugs around connecting/disconnecting to/from MPD servers
- Fixes a bug where holding space would repeatedly send play/pause commands to the server
- Fixes a bug where the app would crash when trying to reconnect to a different server
- Fixes a bug where double clicking on a song to play it would sometimes crash the app

## 0.13.0-alpha - 2019-08-17

### Added

Lots of added functionality!

- Album detail view with the ability to add songs to the queue
- Ability to re-order the queue by dragging songs
- Ability to remove tracks from the queue
- Play next option to enqueue songs

### Changed

- Refactors out the reducer used for queuing MPD actions. It turns out this was not necessary and actually caused problems

## 0.12.0-alpha - 2019-05-18

### Added

- Now Playing information and transport controls in the dock menu
- Queue position numbers in the queue
- Shuffle/repeat mode buttons

### Changed

- BIG refactor using unidirectional dataflow

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

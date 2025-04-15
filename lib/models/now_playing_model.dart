//! contains a `provider` impl for the user's currently playing media, if any.

import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../types.dart';

/// The song that's playing now.
class NowPlayingModel extends ChangeNotifier {
  /// the song we're playing, if any
  Song? _nowPlaying;

  /// a timer to manage the progress of playing the song.
  ///
  /// null when there's no song.
  Timer? _progressTimer;

  /// how much of the song we've played.
  ///
  /// null if no song.
  Duration? _currentTime;

  /// whether we're paused or playing
  Playback _paused = Playback.paused;

  Shuffle _shuffle = Shuffle.off;
  RepeatSetting _repeat = RepeatSetting.off;

  /// a queue of music to play next.
  ///
  /// does not represent the history, which is another field...
  final Queue<Song> _queue = Queue<Song>();

  /// a list of music we've already played since last being cleared.
  final Queue<Song> _history = Queue<Song>();

  /// Grabs the song that's currently playing, if any.
  Song? get nowPlaying => _nowPlaying;

  /// Grabs the current progress.
  ///
  /// Between 0.0 and 1.0, inclusive: [0.0, 1.0].
  ///
  /// Null if there's no song playing.
  double? get progress {
    // if either the song or stopwatch are null, we'll return null too.
    if (_nowPlaying == null || _currentTime == null) {
      return null;
    }

    // grab values and cast as needed
    double totalMs = _nowPlaying!.lengthSeconds * 1000;
    int elapsedMs = _currentTime!.inMilliseconds;

    // divide smaller by larger
    return elapsedMs / totalMs;
  }

  /// Grabs the current time we're at. Can be null if no song.
  Duration? get currentTime => _currentTime;

  /// Checks whether we're paused or playing.
  Playback get paused => _paused;

  /// Accesses the shuffle setting.
  Shuffle get shuffle => _shuffle;

  /// Accesses the repeat setting.
  RepeatSetting get repeat => _repeat;

  // stop our timer
  @override
  void dispose() {
    if (_progressTimer != null) {
      _progressTimer!.cancel();
    }

    super.dispose();
  }

  /// Toggles playback.
  ///
  /// If the current song is null, we'll pause playback no matter what.
  void togglePlayback() {
    if (_nowPlaying != null) {
      switch (_paused) {
        case Playback.playing:
          _paused = Playback.paused;
          _stopTimer();
          break;
        case Playback.paused:
          _paused = Playback.playing;
          _startTimer();
          break;
      }
    } else {
      _paused = Playback.paused;
    }

    notifyListeners();
  }

  /// Plays a song immediately.
  ///
  /// If a song is playing already, that song will be pushed into `history`,
  /// and this new song will play instead.
  void playSong(Song song) {
    log("playing song... ${song.title}");

    // move old song, if any, to history
    if (_nowPlaying != null) {
      _history.addFirst(_nowPlaying!);
    }

    // replace it
    _nowPlaying = song;

    // start the timer
    _startTimer();

    // create the time progression counter
    _currentTime = Duration(); // 0 seconds

    // set the now playing status
    _paused = Playback.playing;

    // send noti to listeners
    notifyListeners();
  }

  /// Immediately pauses the player.
  void pause() {
    log("pausing song... ${nowPlaying?.title}");

    // early return when no song to avoid rerender
    if (_nowPlaying == null) {
      return;
    }

    // we're not null now, so set paused
    _paused = Playback.paused;

    // send noti to listeners
    notifyListeners();
  }

  /// Adds a song to the front of the queue.
  void queueSongFront(Song song) {
    // if the queue's empty, just start playing man
    if (_nowPlaying == null) {
      playSong(song);
      return;
    }

    // otherwise, push to the front
    _queue.addFirst(song);
    notifyListeners();
  }

  /// Adds a song to the back of the queue.
  void queueSongBack(Song song) {
    // if the queue's empty, just start playing man
    if (_nowPlaying == null) {
      playSong(song);
      return;
    }

    // otherwise, push to the back
    _queue.addLast(song);
    notifyListeners();
  }

  /// Skips to the next song, if any.
  void skipNext() {
    log("skipping to next song");

    if (_queue.isNotEmpty) {
      Song next = _queue.removeFirst();
      playSong(next);
    }
  }

  /// Goes back to the previous song, if any.
  ///
  /// This plays the last song added to the history.
  void skipBack() {
    log("skipping to previous song");

    if (_history.isNotEmpty) {
      Song last = _history.removeLast();
      playSong(last);
    }
  }

  /// Clears the queue.
  void clearQueue() {
    log("clearing queue");

    _queue.clear();
    notifyListeners();
  }

  /// Seeks to the given position.
  ///
  /// Must be a value from [0.0, 1.0].
  void seek(double position) {
    log("seeking to position: $position");

    // dont skip around without a song
    if (_nowPlaying == null) {
      return;
    }

    // force given position value to be in bounds
    position = position.clamp(0.0, 1.0);

    // find a nice time from that position
    Duration time = Duration(
        milliseconds: (_nowPlaying!.lengthSeconds * position * 1000).round());

    // swap that into the model
    _currentTime = time;
    notifyListeners();
  }

  /*

  handle shuffle + repeat

  */

  /// Toggles the shuffle feature.
  void toggleShuffle() {
    log("toggled shuffle");

    // swap em
    if (_shuffle == Shuffle.on) {
      _shuffle = Shuffle.off;
    } else {
      _shuffle = Shuffle.on;
    }

    notifyListeners();
  }

  /// Moves between repeat modes.
  void nextRepeatMode() {
    log("swapped repeat mode");

    switch (_repeat) {
      // swap em
      case RepeatSetting.queue:
        _repeat = RepeatSetting.single;
        break;
      case RepeatSetting.single:
        _repeat = RepeatSetting.off;
        break;
      case RepeatSetting.off:
        _repeat = RepeatSetting.queue;
        break;
    }

    // notify
    notifyListeners();
  }

  /*

        handle the timer

  */

  void _timerMarkSongCompleted() {
    log("song marked complete! ${nowPlaying?.title}");

    // reset the timer
    _currentTime = null;

    // just play the next song
    skipNext();
  }

  void _startTimer() {
    log("start timer");

    // cancel any existing timer
    if (_progressTimer != null) {
      _progressTimer!.cancel();
    }

    // avoid starting timer for no song
    if (_nowPlaying == null) {
      return;
    }

    // start a new timer now
      // we'll update every 200ms
      const Duration(milliseconds: 200),

      // this callback just checks if we're done with the song yet
      () {
        // if we're done, mark the song as done!
        if (_nowPlaying != null &&
            _currentTime! >= Duration(seconds: _nowPlaying!.lengthSeconds)) {
          _timerMarkSongCompleted();
        }

        // otherwise, just update all the things relying on our data
        if (_currentTime != null) {
          _currentTime = _currentTime! + Duration(milliseconds: 200);
        }

        notifyListeners();
      },
    );
  }

  void _stopTimer() {
    log("stop timer");

    _progressTimer?.cancel();
    _progressTimer = null;
  }
}

/// Whether the player is currently playing anything right now.
enum Playback {
  playing,
  paused,
}

/// Whether shuffle is on or off.
enum Shuffle {
  on,
  off,
}

/// Repeat behavior.
enum RepeatSetting {
  /// We'll replay the whole queue over and over again.
  queue,

  /// Play the current song forever.
  single,

  /// No special handling.
  off,
}

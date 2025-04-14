//! contains a `provider` (library) implementation to hold the user's library.

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../tabs/library.dart';

/// The user's library collection... wrapped into a type to allow us to
/// use/modify it from anywhere! :D
class LibraryModel extends ChangeNotifier {
  /// the actual collection
  final List<LibraryEntry> _libraryEntries =
      List<LibraryEntry>.empty(growable: true);

  /// Grabs the library collection as a slice.
  UnmodifiableListView<LibraryEntry> get libraryEntries =>
      UnmodifiableListView(_libraryEntries);

  /// Adds a new entry to the user's library.
  ///
  /// If a entry of the same name already exists, this will throw an error.
  void addEntry(LibraryEntry newEntry) {
    // check if it already exists...
    if (_libraryEntries.any((entry) => entry.name == newEntry.name)) {
      throw ArgumentError.value(newEntry, "newEntry", "Entry already exists.");
    }

    // we're all clear - no such entry exists yet!
    _libraryEntries.add(newEntry);
    notifyListeners();
  }

  /// Deletes an entry (playlist/album) from the user's library.
  ///
  /// This is immediate and irreversible. Make sure to ask the user for
  /// confirmation.
  ///
  /// Throws an error if the entry doesn't exist.
  void deleteEntry(String entryName) {
    // check if the entry even exists.
    //
    // if it does, find its index so we can remove it...
    int? matchingIndex;
    _libraryEntries.firstWhereIndexedOrNull((int index, LibraryEntry entry) {
      matchingIndex = index;
      return entry.name == entryName;
    });

    // if we got an index, remove that from the list
    if (matchingIndex != null) {
      _libraryEntries.removeAt(matchingIndex!);
      notifyListeners();
    } else {
      // otherwise, throw an error
      throw ArgumentError.value(
          entryName, "entryName", "The given library entry was not found.");
    }
  }

  /// Adds a song to a playlist.
  ///
  /// If the name of an album is given, or if the playlist doesn't exist, this
  /// will throw an error.
  void addSongToPlaylist(String playlistName, Song song) {
    // try to find the playlist
    LibraryEntry? maybeEntry = _libraryEntries
        .firstWhereOrNull((LibraryEntry entry) => entry.name == playlistName);

    // if it doesn't exist, throw an error
    if (maybeEntry == null) {
      throw ArgumentError.value(playlistName, "playlistName",
          "Given playlist not found. Please try again later.");
    }

    // throw an error if it's actually an album
    LibraryEntry entry = maybeEntry;
    if (entry.type == LibraryEntryType.album) {
      throw ArgumentError("You cannot add a song to an album.");
    }

    // alright, we're all good!
    LibraryEntry playlist = entry;
    playlist.songs.add(song);
    notifyListeners();
  }

  /// Removes a song from a playlist.
  ///
  /// Throws an error if the playlist doesn't exist, the index is too high/low,
  /// or the playlist name given leads to an album.
  void removeSongFromPlaylist(int index, String playlistName) {
    // try to get the playlist
    LibraryEntry? maybeEntry = _libraryEntries
        .firstWhereOrNull((LibraryEntry entry) => entry.name == playlistName);

    // if the playlist doesn't exist, throw an error
    if (maybeEntry == null) {
      throw ArgumentError.value(playlistName, "playlistName",
          "Given playlist not found. Please try again later.");
    }

    // err if the playlist is an album
    if (maybeEntry.type == LibraryEntryType.album) {
      throw ArgumentError("You cannot add a song to an album.");
    }

    // ok, error if the given index is too high/low
    Song? songToRemove = maybeEntry.songs.elementAtOrNull(index);
    if (songToRemove == null) {
      throw ArgumentError.value(
          index, "index", "The given song was not found in the playlist.");
    }

    // welp... we can remove the song now
    maybeEntry.songs.removeAt(index);
    notifyListeners();
  }
}

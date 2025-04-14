//! contains a `provider` (library) implementation to hold the user's library.

import 'package:collection/collection.dart';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/foundation.dart';

import '../types.dart';

/// The user's library collection... wrapped into a type to allow us to
/// use/modify it from anywhere! :D
class LibraryModel extends ChangeNotifier {
  /// the actual collection
  final List<LibraryEntry> _libraryEntries =
      List<LibraryEntry>.empty(growable: true);

  /// constructor, which will set up the initial values
  LibraryModel() {
    // Machine Girl album i like
    _libraryEntries.add(machineGirlAlbum());

    // make a very long playlist from rng'd values
    _libraryEntries.add(bigPlaylist());

    // more albums
    _libraryEntries.addAll([
      sbNoLongerFearRazorGuardingMyHeel(),
      sbNoLongerFearRazorGuardingMyHeelIii(),
    ]);
  }

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

  /// Returns a filtered, sorted library based on the given options.
  UnmodifiableListView<LibraryEntry> filteredSortedEntries(
      FilterOption filters, SortOption sortMode, SortDirection sortDirection) {
    // clone and filter the list
    List<LibraryEntry> filtered = _libraryEntries.where((entry) {
      switch (filters) {
        case FilterOption.all:
          return true;
        case FilterOption.playlists:
          return entry.type == LibraryEntryType.playlist;
        case FilterOption.albums:
          return entry.type == LibraryEntryType.album;
      }
    }).toList();

    // sort that list
    filtered.sort((a, b) => comp(a, b, sortMode, sortDirection));

    // return that filtered, sorted list
    return UnmodifiableListView(filtered);
  }
}

/// internal function that can compare two library entries based on the given
/// sorting options.
int comp(LibraryEntry a, LibraryEntry b, SortOption sortMode,
    SortDirection sortDirection) {
  LibraryEntry one;
  LibraryEntry two;

  if (sortDirection == SortDirection.descending) {
    one = b;
    two = a;
  } else {
    one = a;
    two = b;
  }

  switch (sortMode) {
    case SortOption.alphabetical:
      return one.name.toLowerCase().compareTo(two.name.toLowerCase());
    case SortOption.lastModified:
      return one.lastModified.compareTo(two.lastModified);
    case SortOption.creator:
      return (one.creator ?? "").compareTo(two.creator ?? "");
    case SortOption.recentlyAdded:
      return one.dateAdded.compareTo(two.dateAdded);
  }
}

/*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
* initial state creators below. not too important lol
*
*/

LibraryEntry bigPlaylist() {
  List<Song> list = List.empty(growable: true);

  // make 1000 songs lol
  for (int i in Iterable.generate(1000)) {
    final songTitle = 'Song ${i + 1}';
    final artists = [
      "potsu",
      "GNB CHILI",
      "\$uicideboy\$",
      "Berlioz",
      "Daft Punk",
      "Nujabes",
      "SAINT PEPSI",
      "DJ Boring",
      "Deathbrain",
      "Sia",
      "Eevee",
      "Men at Work"
    ];
    final albums = [
      "Sing Me A Lullaby, My Sweet Temptation",
      "unexpected",
      "Everyday is Christmas (Deluxe Edition)",
      "World Champion",
      "Basement Popstar",
      "Long Term Effects of Suffering",
      "Either Hated Or Ignored",
      "ivy league",
      "Cargo",
      "Business As Usual",
    ];

    final randomArtist = randomChoice(artists);
    final randomAlbum = randomChoice(albums);
    final randomArt = "https://picsum.photos/seed/$i/256";

    list.add(Song(
      title: songTitle,
      artist: randomArtist,
      albumName: randomAlbum,
      art: randomArt,
      lengthSeconds: 120,
    ));
  }

  // return the list we made inside a LibraryEntry playlist
  return LibraryEntry(
      name: "giant playlist",
      dateAdded: DateTime.utc(2025, 04, 01),
      songs: list,
      art: "https://picsum.photos/1024",
      type: LibraryEntryType.playlist,
      lastModified: DateTime.now(),
      creator: "barrett");
}

LibraryEntry machineGirlAlbum() {
  final String albumName =
      "...BECAUSE IM YOUNG ARROGANT AND HATE EVERYTHING YOU STAND FOR";
  final String art = "https://f4.bcbits.com/img/a2967787180_16.jpg";
  final String artist = "Machine Girl";

  return LibraryEntry(
    name: albumName,
    dateAdded: DateTime.now(),
    artist: artist,

    // pretend these are correct pls
    songs: [
      for (int _ in Iterable.generate(8))
        Song(
            title: "うずまき",
            albumName: albumName,
            art: art,
            artist: artist,
            lengthSeconds: (2 * 60) + 47)
    ],
    art: art,
    type: LibraryEntryType.album,
    lastModified: DateTime.utc(2017, 12, 27),
  );
}

LibraryEntry sbNoLongerFearRazorGuardingMyHeel() {
  final String albumName = "I NO LONGER FEAR THE RAZOR GUARDING MY HEEL";
  final String art =
      "https://lastfm.freetls.fastly.net/i/u/1024x0/f6af794b04110d90cbc9148b9f61a20a.jpg";
  final String artist = "\$uicideboy\$";

  return LibraryEntry(
    name: albumName,
    dateAdded: DateTime.now(),
    artist: artist,

    // pretend these are correct pls
    songs: [
      Song(
        title: "My Flaws Burn Through My Skin Like Demonic Flames from Hell",
        albumName: albumName,
        art: art,
        artist: artist,
        lengthSeconds: (2 * 60) + 47,
      ),
      Song(
        title: "My Scars Are Like Evidence Being Mailed to the Judge",
        albumName: albumName,
        art: art,
        artist: artist,
        lengthSeconds: (2 * 60) + 2,
      ),
      Song(
        title:
            "I Will Celebrate for Stepping on Broken Glass and Slipping on Stomach Soaked Floors",
        albumName: albumName,
        art: art,
        artist: artist,
        lengthSeconds: (2 * 60) + 18,
      ),
    ],
    art: art,
    type: LibraryEntryType.album,
    lastModified: DateTime.utc(2015, 8, 1),
  );
}

LibraryEntry sbNoLongerFearRazorGuardingMyHeelIii() {
  final String albumName = "I NO LONGER FEAR... (III)";
  final String art =
      "https://lastfm.freetls.fastly.net/i/u/2048x0/2cda72350d018777e8a07c9065067386.jpg";
  final String artist = "\$uicideboy\$";

  return LibraryEntry(
    name: albumName,
    dateAdded: DateTime.now(),
    artist: artist,

    // pretend these are correct pls
    songs: [
      Song(
        title:
            "If You Were to Get What You Deserve, You Would Know What the Bottom of a Tire Tastes Like",
        albumName: albumName,
        art: art,
        artist: artist,
        lengthSeconds: (2 * 60) + 37,
      ),
      Song(
        title: "Soul Doubt",
        albumName: albumName,
        art: art,
        artist: artist,
        lengthSeconds: (2 * 60) + 0,
      ),
      Song(
        title: "All That Glitters Is Not Gold, But It's Still Damn Beautiful",
        albumName: albumName,
        art: art,
        artist: artist,
        lengthSeconds: (2 * 60) + 17,
      ),
    ],
    art: art,
    type: LibraryEntryType.album,
    lastModified: DateTime.utc(2016, 12, 17),
  );
}

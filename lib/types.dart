enum LibraryEntryType {
  playlist,
  album,
}

class LibraryEntry {
  final String name;
  final List<Song> songs;
  final String? art; // link to an image
  final String? artist; // artist name (album)
  final String? creator; // account name (playlist)
  final LibraryEntryType type;
  final DateTime lastModified;
  final DateTime dateAdded;

  LibraryEntry({
    required this.name,
    required this.songs,
    this.art,
    this.artist,
    this.creator,
    required this.type,
    required this.lastModified,
    required this.dateAdded,
  });

  int get songCount => songs.length;

  Map<String, dynamic> toJson() => {
        'name': name,
        'songs': songs.map((song) => song.toJson()).toList(),
        'art': art,
        'artist': artist,
        'creator': creator,
        'type': type.toString(),
        'lastModified': lastModified.toIso8601String(),
        'dateAdded': dateAdded.toIso8601String(),
      };
}

class Song {
  final String title;
  final String artist;
  final String? albumName;
  final int lengthSeconds;
  final String? art; // link to an image

  Song({
    required this.title,
    required this.artist,
    this.albumName,
    this.art,
    required this.lengthSeconds,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'artist': artist,
        'albumName': albumName,
        'art': art,
        'lengthSeconds': lengthSeconds,
      };
}

enum SortOption {
  lastModified('Last Modified'),
  alphabetical('Alphabetical'),
  creator('Creator'),
  recentlyAdded('Recently Added');

  const SortOption(this.label);
  final String label;
}

enum FilterOption {
  all('All'),
  playlists('Playlists'),
  albums('Albums');

  const FilterOption(this.label);
  final String label;
}

enum SortDirection {
  ascending,
  descending,
}

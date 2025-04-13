import 'package:flutter/material.dart';
import '../components/navbar.dart';
import '../subroutes/add_playlist.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  final String title = "Library";
  static final String route = "library";

  @override
  State<LibraryPage> createState() => _LibraryPageState();
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

class _LibraryPageState extends State<LibraryPage> {
  List<LibraryEntry> libraryEntries = List<LibraryEntry>.empty(growable: true);
  SortOption selectedSortMode = SortOption.lastModified;
  FilterOption currentFilter = FilterOption.all;
  SortDirection sortDirection = SortDirection.descending;

  @override
  void initState() {
    super.initState();
    libraryEntries.add(LibraryEntry(
      name: "...BECAUSE IM YOUNG ARROGANT AND HATE EVERYTHING YOU STAND FOR",
      dateAdded: DateTime.now(),
      songs: [
        Song(
            title: "うずまき",
            albumName:
                "...BECAUSE IM YOUNG ARROGANT AND HATE EVERYTHING YOU STAND FOR",
            art: "https://f4.bcbits.com/img/a2967787180_16.jpg",
            artist: "Machine Girl"),
      ],
      art: "https://f4.bcbits.com/img/a2967787180_16.jpg",
      type: LibraryEntryType.album,
      lastModified: DateTime.utc(2017, 12, 27),
    ));
    // TODO: add a bunch of stuff here.
  }

  void sortLibrary() {
    setState(() {
      int t(LibraryEntry a, LibraryEntry b) {
        LibraryEntry larger;
        LibraryEntry smaller;

        if (sortDirection == SortDirection.descending) {
          larger = b;
          smaller = a;
        } else {
          larger = a;
          smaller = b;
        }

        if (selectedSortMode == SortOption.alphabetical) {
          return larger.name
              .toLowerCase()
              .compareTo(smaller.name.toLowerCase());
        } else if (selectedSortMode == SortOption.lastModified) {
          return larger.lastModified.compareTo(smaller.lastModified);
        } else if (selectedSortMode == SortOption.creator) {
          return (larger.creator ?? "").compareTo(smaller.creator ?? "");
        } else if (selectedSortMode == SortOption.recentlyAdded) {
          //
          return larger.dateAdded.compareTo(smaller.dateAdded);
        }

        // this should never happen
        throw Error();
      }

      libraryEntries.sort((a, b) => t(a, b));
    });
  }

  List<LibraryEntry> filterLibraryEntries() {
    return libraryEntries.where((entry) {
      switch (currentFilter) {
        case FilterOption.all:
          return true;
        case FilterOption.playlists:
          return entry.type == LibraryEntryType.playlist;
        case FilterOption.albums:
          return entry.type == LibraryEntryType.album;
      }
    }).toList();
  }

  void filterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter',
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    children: FilterOption.values.map((filter) {
                      return ChoiceChip(
                        label: Text(filter.label),
                        selected: currentFilter == filter,
                        onSelected: (selected) {
                          if (selected) {
                            setSheetState(() {
                              currentFilter = filter;
                            });
                            setState(() {});
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sort by',
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    children: SortOption.values.map((sort) {
                      return ChoiceChip(
                        label: Text(sort.label),
                        selected: selectedSortMode == sort,
                        onSelected: (selected) {
                          if (selected) {
                            setSheetState(() {
                              selectedSortMode = sort;
                            });
                            setState(() {
                              sortLibrary();
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Descending order'),
                    value: sortDirection == SortDirection.ascending,
                    onChanged: (value) {
                      setSheetState(() {
                        if (value) {
                          sortDirection = SortDirection.ascending;
                        } else {
                          sortDirection = SortDirection.descending;
                        }
                      });
                      setState(() {
                        sortLibrary();
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEntryOptions(BuildContext context, LibraryEntry entry) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: const Text('Edit details'),
          onTap: () => {},
        ),
        PopupMenuItem(
          child: const Text('Delete'),
          onTap: () => {},
        ),
        PopupMenuItem(
          child: const Text('Download'),
          onTap: () => {},
        ),
        PopupMenuItem(
          child: const Text('Share'),
          onTap: () => {},
        ),
      ],
    );
  }

  void _navigateToCreatePlaylist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPlaylistPage(),
      ),
    );
  }

  void _navigateToEntryDetails(LibraryEntry entry) {
    // TODO(bray): go to playlist/album view
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = filterLibraryEntries();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToCreatePlaylist,
            tooltip: 'Create new playlist',
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              setState(() {
                if (sortDirection == SortDirection.ascending) {
                  sortDirection = SortDirection.descending;
                } else {
                  sortDirection = SortDirection.ascending;
                }
                sortLibrary();
              });
            },
            tooltip: sortDirection == SortDirection.ascending
                ? 'Sort ascending'
                : 'Sort descending',
          ),
        ],
      ),
      body: Column(
        children: [
          // the chips at the top to filter
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Chip(
                  label: Text(selectedSortMode.label),
                  onDeleted: null,
                  avatar: Icon(Icons.sort,
                      size: 18, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 8),
                currentFilter != FilterOption.all
                    ? Chip(
                        label: Text(currentFilter.label),
                        onDeleted: () {
                          setState(() {
                            currentFilter = FilterOption.all;
                          });
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),

          // list of all the stuff
          Expanded(
            // if we have any entries, we'll show em.
            //
            // if not, show an empty list redirection
            child: () {
              if (filteredEntries.isEmpty) {
                return emptyList();
              } else {
                return makeList(filteredEntries);
              }
            }(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: filterSheet,
        tooltip: "filter the library",
        child: const Icon(Icons.filter_list),
      ),
      bottomNavigationBar: BottomNavigation(
          currentRoute: LibraryPage.route, onRouteChanged: (s) => ()),
    );
  }

  ListView makeList(List<LibraryEntry> entries) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];

        // make a big ahh card for that entry
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: InkWell(
            onTap: () => _navigateToEntryDetails(entry),
            onLongPress: () => _showEntryOptions(context, entry),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      entry.art,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 64,
                          height: 64,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            entry.type == LibraryEntryType.playlist
                                ? Icons.queue_music
                                : entry.type == LibraryEntryType.album
                                    ? Icons.album
                                    : Icons.person,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (entry.artist != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            entry.artist!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          '${entry.songCount} ${entry.songCount == 1 ? 'song' : 'songs'}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),

                  // three dots menu
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showEntryOptions(context, entry),
                    tooltip: 'More options',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // TODO(bray): tell the user if it's empty bc of filters
  //
  // rn it awkwardly says it's empty, even if the filters just make it so
  Center emptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // show the library icon
          Icon(
            Icons.library_music,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),

          // tell the user it's empty
          const SizedBox(height: 16),
          Text(
            "Your library is empty",
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          // tellt hem how to make it not empty lol
          const SizedBox(height: 8),
          Text(
            'Make a playlist to organize your music!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),

          // show them two buttons:
          //
          // - create new playlist
          // - search for music
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _navigateToCreatePlaylist,
            icon: const Icon(Icons.add),
            label: const Text('Create Playlist'),
          ),
        ],
      ),
    );
  }
}

enum LibraryEntryType {
  playlist,
  album,
}

class LibraryEntry {
  final String name;
  final List<Song> songs;
  final String art; // link to an image
  final String? artist; // artist name (album)
  final String? creator; // account name (playlist)
  final LibraryEntryType type;
  final DateTime lastModified;
  final DateTime dateAdded;

  LibraryEntry({
    required this.name,
    required this.songs,
    required this.art,
    this.artist,
    this.creator,
    required this.type,
    required this.lastModified,
    required this.dateAdded,
  });

  int get songCount => songs.length;
}

class Song {
  final String title;
  final String artist;
  final String? albumName;
  final int lengthSeconds;
  final String art; // link to an image

  Song({
    required this.title,
    required this.artist,
    this.albumName,
    required this.art,
    required this.lengthSeconds,
  });
}

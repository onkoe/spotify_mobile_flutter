import 'dart:developer';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_mobile_flutter/components/user_options.dart';
import 'package:spotify_mobile_flutter/types.dart';
import '../components/navbar.dart';
import '../models/library_model.dart';
import '../subroutes/add_playlist.dart';
import '../subroutes/playlist.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  final String title = "Library";
  static final String route = "library";

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  SortOption selectedSortMode = SortOption.lastModified;
  FilterOption currentFilter = FilterOption.all;
  SortDirection sortDirection = SortDirection.descending;

  @override
  void initState() {
    super.initState();
  }

  void _addPlaylist(LibraryEntry playlist) {
    try {
      Provider.of<LibraryModel>(context, listen: false).addEntry(playlist);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  /// shows the user options.
  void _userOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UserOptionsDialog();
        });
  }

  /// shows filter options.
  void _filterSheet() {
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
                  // header to say that we're in the filter + sort options
                  Center(
                    child: Text(
                      'Filter and Sort',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // show the filter options first
                  Text(
                    'Filter options',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(height: 1.0),
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

                  // and then the sort options
                  Text(
                    'Sort by',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(height: 1.0),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: SortOption.values.map((sort) {
                      return ChoiceChip(
                        label: Text(sort.label),
                        selected: selectedSortMode == sort,
                        onSelected: (selected) {
                          if (selected) {
                            setSheetState(() {
                              selectedSortMode = sort;
                            });
                            setState(() {}); // require rebuild
                          }
                        },
                      );
                    }).toList(),
                  ),

                  // also, let users put it in descending order
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
                        setState(() {}); // require rebuild
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

  Row _makeEntryCard(
    BuildContext context,
    LibraryEntry entry,
  ) {
    return Row(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: () {
            if (entry.art != null) {
              return CachedNetworkImage(
                  imageUrl: entry.art!,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover);
            } else {
              return Icon(Icons.error);
            }
          }(),
        ),
        const SizedBox(width: 16),
        // info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.0,
            children: [
              Text(
                entry.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // show the lowest text
              Text(
                entry.artist ?? "Made by ${entry.creator ?? "an unknown user"}",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              Text(
                // set the text
                () {
                  // for playlists, return the song ct
                  if (entry.type == LibraryEntryType.playlist) {
                    String suffix = entry.songCount == 1 ? "song" : "songs";
                    return "Playlist • ${entry.songCount} $suffix";
                  } else if (entry.type == LibraryEntryType.album) {
                    // but, for albums, we should return the artist
                    if (entry.artist == null) {
                      log("null artist on entry: ${JsonEncoder.withIndent('  ').convert(entry.toJson())}");
                      return "Failed to get artist";
                    }
                    String suffix = entry.songCount == 1 ? "song" : "songs";

                    return "Album • ${entry.songCount} $suffix";
                  } else {
                    return "couldn't find necessary info";
                  }
                }(),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ),

        // three dots menu
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => _rightClickMenu(context, entry),
          tooltip: "More options",
        ),
      ],
    );
  }

  /// a list of items to appear in an entry's right click menu...
  List<PopupMenuItem<dynamic>> _rightClickMenu(
      BuildContext context, LibraryEntry entry) {
    log("about to show menu for entry: ${entry.name}");

    return [
      // when a user taps Open, send em to the list
      PopupMenuItem(
        child: const ListTile(
          leading: Icon(Icons.edit),
          title: Text("Open"),
        ),
        onTap: () => _navigateToEntryDetails(entry),
      ),

      // we can only delete playlists. if it's a playlist, we're only
      // removing it...
      if (entry.type == LibraryEntryType.playlist)
        PopupMenuItem(
          child: const ListTile(
            leading: Icon(Icons.delete),
            title: Text("Delete playlist..."),
          ),
          onTap: () => Future.delayed(Duration.zero, () async {
            await _promptUserOnPlaylistDeletion(entry);
          }),
        )
      else
        PopupMenuItem(
          child: const ListTile(
            leading: Icon(Icons.delete),
            title: Text("Remove from library..."),
          ),
          onTap: () => Future.delayed(Duration.zero, () async {
            await _promptUserOnAlbumRemoval(entry);
          }),
        ),

      // TODO(bray): show if playlist isn't marked as downloaded already.
      //
      // otherwise, show 'Remove from Downloads...'
      PopupMenuItem(
        child: const ListTile(
          leading: Icon(Icons.download),
          title: Text("Download"),
        ),
        onTap: () => {},
      ),

      PopupMenuItem(
        child: const ListTile(
          leading: Icon(Icons.share),
          title: Text("Share"),
        ),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: () {
            switch (entry.type) {
              case LibraryEntryType.album:
                return Text("Copied album link to clipboard");
              case LibraryEntryType.playlist:
                return Text("Copied playlist link to clipboard");
            }
          }(),
        )),
      ),
    ];
  }

  void _navigateToCreatePlaylist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPlaylistPage(),
      ),
    ).then((createdPlaylist) {
      if (createdPlaylist != null) {
        _addPlaylist(createdPlaylist);
      }
    });
  }

  void _navigateToEntryDetails(LibraryEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistPage(entry: entry),
      ),
    );
  }

  /// asks the user if they'd really like to delete a playlist.
  Future<bool?> _promptUserOnPlaylistDeletion(LibraryEntry entry) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Delete playlist"),
        content: const Text("Are you sure you wish to delete this playlist?"),
        actions: <Widget>[
          // give them a chance to cancel
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),

          // dangerous action: delete (red)
          TextButton(
            onPressed: () {
              // try to delete the entry
              try {
                log("attempting to delete entry: ${entry.name}");
                Provider.of<LibraryModel>(context, listen: false)
                    .deleteEntry(entry.name);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }

              // no matter what, pop ourselves off the navigator stack
              Navigator.pop(context, true);
            },

            // make it red
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),

            // text
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  /// asks the user if they'd really like to remove an album from their
  /// collection.
  Future<bool?> _promptUserOnAlbumRemoval(LibraryEntry entry) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Remove album"),
        content: const Text(
            "Are you sure you wish to remove this album from your collection?"),
        actions: <Widget>[
          // give them a chance to cancel
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),

          // dangerous action: remove from library
          TextButton(
            onPressed: () {
              // try to remove the entry
              try {
                log("attempting to remove entry: ${entry.name}");
                Provider.of<LibraryModel>(context, listen: false)
                    .deleteEntry(entry.name);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }

              // no matter what, pop ourselves off the navigator stack
              Navigator.pop(context, true);
            },

            // make it red
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),

            // text
            child: Text("Remove"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),

        // stuff at the top right
        actions: [
          // filter/sort sheet button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _filterSheet,
            tooltip: "Filter and sort your library",
          ),

          // user icon for settings and such
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _userOptions,
            tooltip: "User settings",
          ),

          // fix: dumb lack of padding on right side (i.e. Flutter fails to
          // adhere to Material 3 spec)
          //
          // for more info, see:
          //
          // https://github.com/flutter/flutter/issues/91884#issuecomment-1730037283
          Padding(padding: EdgeInsets.only(right: 16)),
        ],
      ),

      // alright, now we'll show off the user's library
      body: Column(
        children: [
          // list of all the stuff
          Expanded(
            // if we have any entries, we'll show em.
            //
            // if not, show an empty list redirection
            child:
                Consumer<LibraryModel>(builder: (context, libraryModel, child) {
              final UnmodifiableListView<LibraryEntry> filteredEntries =
                  libraryModel.filteredSortedEntries(
                      currentFilter, selectedSortMode, sortDirection);

              if (filteredEntries.isEmpty) {
                return _emptyList();
              } else {
                return _makeList(filteredEntries);
              }
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePlaylist,
        tooltip: "Create a new playlist",
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(
          currentRoute: LibraryPage.route, onRouteChanged: (s) => ()),
    );
  }

  ListView _makeList(List<LibraryEntry> entries) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];

        void makeMenu(BuildContext context, TapDownDetails details) {
          log("ooh makeMenu called?");

          showMenu(
            context: context,
            items: _rightClickMenu(context, entry),

            // FIXME(bray): no way this is idiomatic flutter lmao
            position: RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              details.globalPosition.dx,
              details.globalPosition.dy,
            ),
          );
        }

        // make a big ahh card for that entry
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: InkWell(
            onTap: () => _navigateToEntryDetails(entry),
            onSecondaryTapDown: (details) => makeMenu(context, details),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _makeEntryCard(context, entry),
            ),
          ),
        );
      },
    );
  }

  // TODO(bray): tell the user if it's empty bc of filters
  //
  // rn it awkwardly says it's empty, even if the filters just make it so
  Center _emptyList() {
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
          // - TODO(bray): search for music
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _navigateToCreatePlaylist,
            icon: const Icon(Icons.add),
            label: const Text('Create a new playlist'),
          ),
        ],
      ),
    );
  }
}

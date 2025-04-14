//! This file is just a screen to add a new playlist to your library.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../tabs/library.dart';

class AddPlaylistPage extends StatefulWidget {
  const AddPlaylistPage({super.key});

  final String title = "Add new playlist";
  static final String route = "add_playlist";

  @override
  State<AddPlaylistPage> createState() => _AddPlaylistPageState();
}

class _AddPlaylistPageState extends State<AddPlaylistPage> {
  List<Song> songs = List.empty(growable: true);
  String? art;
  final TextEditingController _name = TextEditingController();
  bool public = true;

  @override
  void initState() {
    super.initState();
  }

  void setPublic(bool b) {
    setState(() {
      public = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // just say "add new playlist" up top
      appBar: AppBar(
        title: const Text('Add new playlist'),
      ),

      // body contains settings on the playlist
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            makePlaylistArtIcon(),
            SizedBox(height: 16),

            // naming the playlist
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Playlist name",
                hintText: "ex: Favs from 2020",
              ),
            ),
            SizedBox(height: 16),

            SwitchListTile(
              onChanged: setPublic,
              value: public,
              title: Text("Public"),
              subtitle: () {
                if (public) {
                  return Text(
                    "Your playlist will be visible to all Spotify users, and anyone can share/copy it.",
                  );
                } else {
                  return Text("Only you can see this playlist.");
                }
              }(),
            ),
          ],
        ),
      ),

      // save button
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Save playlist"),
        icon: Icon(Icons.save),
        onPressed: () {
          // before anything, check that the name isn't blank
          if (_name.text.isEmpty) {
            // Show error message to tell user to enter a name
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Please enter a name for your playlist.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer),
                ),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
            );
            return;
          }

          // if the art is blank or null, we'll set that
          if (art != null && art!.isEmpty) {
            art = "https://picsum.photos/1024";
          }

          LibraryEntry playlist = LibraryEntry(
            dateAdded: DateTime.now(),
            songs: List.empty(growable: true),
            name: _name.text,
            lastModified: DateTime.now(),
            type: LibraryEntryType.playlist,
            art: art,
          );

          Navigator.pop(context, playlist);
        },
      ),
    );
  }

  /// shows the user a dialog asking for a link to an image for their
  /// playlist's art.
  ///
  /// TOOD(bray): this should be refactored, it's ugly-ahh copilot'd code.
  Future<String?> artDialog(BuildContext context) async {
    TextEditingController urlController = TextEditingController();
    bool hasImage = false; // we'll need a working image to continue...
    String currentUrl = ''; // the url the user gave

    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Playlist Art'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,

                  // the alert dialog has some stuff to help find the image
                  // under here...
                  children: [
                    TextField(
                        controller: urlController,
                        decoration: const InputDecoration(
                            labelText: 'Image URL',
                            hintText: 'Enter a valid image URL'),

                        // when the user gives another image, make sure we
                        // hate it by default
                        onChanged: (value) {
                          if (value != currentUrl) {
                            setState(() {
                              hasImage = false;
                              currentUrl = value;
                            });
                          }
                        }),

                    // show the image, if we have one
                    const SizedBox(height: 16),
                    if (urlController.text.isNotEmpty)
                      Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),

                          // cache it, too
                          child: CachedNetworkImage(
                              imageUrl: urlController.text,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                      child:
                                          Icon(Icons.error, color: Colors.red)),
                              fit: BoxFit.cover,
                              imageBuilder: (context, imageProvider) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  setState(() {
                                    hasImage = true;
                                  });
                                });
                                return Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover)));
                              }))
                  ],
                ),

                // allow user to continue with/cancel this change
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: hasImage
                        ? () {
                            Navigator.of(context).pop(urlController.text);
                          }
                        : null,
                    child: const Text('OK'),
                  )
                ]);
          });
        });
  }

  Widget makePlaylistArtIcon() {
    return GestureDetector(
      onTap: () async {
        final String? newArt = await artDialog(context);
        if (newArt != null) {
          setState(() {
            art = newArt;
          });
        }
      },
      child: Stack(
        children: [
          // show the image art, if we've got it, or a random placeholder from
          // the default image.
          if (art != null)
            CachedNetworkImage(
              imageUrl: art!,
              width: 128,
              height: 128,
              fit: BoxFit.cover,
            )
          else
            CachedNetworkImage(
              imageUrl: "https://picsum.photos/256",
              width: 128,
              height: 128,
              fit: BoxFit.cover,
            ),

          // overlay an edit icon
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: IconButton.filled(
                onPressed: () async {
                  final String? newArt = await artDialog(context);
                  if (newArt != null) {
                    setState(() {
                      art = newArt;
                    });
                  }
                },
                icon: Icon(
                  Icons.edit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

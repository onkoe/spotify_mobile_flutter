//! A playlist you can browse through.

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../components/navbar.dart';
import '../components/songlist.dart';
import '../tabs/library.dart';
import '../types.dart';

class PlaylistPage extends StatefulWidget {
  final LibraryEntry entry;
  static final String route = "recommendations";

  const PlaylistPage({super.key, required this.entry});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late final LibraryEntry entry;

  @override
  void initState() {
    super.initState();
    entry = widget.entry;
  }

  @override
  Widget build(BuildContext context) {
    String title;

    switch (entry.type) {
      case LibraryEntryType.playlist:
        title = "Playlist";
      case LibraryEntryType.album:
        title = "Album";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      // show the playlist stuff
      body: CustomScrollView(slivers: [
        // header stuff
        SliverToBoxAdapter(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // a little padding
              SizedBox(height: 8),

              // show playlist art and name
              () {
                double imgSize = min(MediaQuery.of(context).size.width * 0.45,
                    MediaQuery.of(context).size.height * 0.5);

                if (entry.art != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: entry.art!,
                      width: imgSize,
                      height: imgSize,
                      fit: BoxFit.fitHeight,
                    ),
                  );
                } else {
                  return Placeholder(
                    fallbackWidth: imgSize,
                    fallbackHeight: imgSize,
                  );
                }
              }(),

              const SizedBox(height: 12),

              // title
              Text(
                entry.name,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        )),

        // show all the songs in the playlist
        SliverFillRemaining(
          hasScrollBody: true,
          child: SongList(songs: entry.songs),
        )
      ]),

      // navbar, pointing to the library tab
      bottomNavigationBar: BottomNavigation(
        currentRoute: LibraryPage.route,
        onRouteChanged: (s) => (),
      ),
    );
  }
}

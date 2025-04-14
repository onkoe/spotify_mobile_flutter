//! A playlist you can browse through.

import 'package:flutter/material.dart';

import '../components/songlist.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // show playlist art and name
            Text("playlist art and name"),

            // show all the songs in the playlist
            Expanded(
              child: SongList(songs: entry.songs),
            )
          ],
        ),
      ),
    );
  }
}

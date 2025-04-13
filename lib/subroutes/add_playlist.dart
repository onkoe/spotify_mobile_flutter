//! This file is just a screen to add a new playlist to your library.

import 'package:flutter/material.dart';

import '../components/songlist.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new playlist'),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(children: [
          // empty art
          Image.network("https://picsum.photos/256",
              width: 128, height: 128, fit: BoxFit.cover),
          Text("Art", style: Theme.of(context).textTheme.titleLarge),
          Text("Adjust your playlist's art",
              style: Theme.of(context).textTheme.bodyLarge),

          // naming the playlist
          Text("Name"),
          Text("Give your playlist a name"),
          TextField(),

          // adding songs
          Text("Songs"),
          Text(
              "Add, remove, and sort songs in the list below. You can always change these later."),
          SongList(songs: songs),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  final String title = "Library";

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<LibraryEntry> libraryEntries = List<LibraryEntry>.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("library"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => (), // TODO: make this filter lol
        tooltip: "Filter your library",
        child: const Icon(Icons.filter),
      ),
    );
  }
}

class LibraryEntry {
  final String name;
  final List<Song> songs;
  final String image; // link to an image

  LibraryEntry({required this.name, required this.songs, required this.image});
}

class Song {
  final String title;
  final String artist;
  final String? albumName;
  final String art; // link to an image

  Song(
      {required this.title,
      required this.artist,
      this.albumName,
      required this.art});
}

//! A list of songs.
//!
//! Used in playlists, albums, and other views of multiple songs.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../types.dart';

class SongList extends StatelessWidget {
  final List<Song> songs;

  const SongList({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(16.0),

            // style it
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16.0),
            ),

            // add the (potentially huge) list of stuff
            // child: SizedBox(
            child: ListView.builder(
                // we'll only handle this many songs
                itemCount: songs.length,

                // set a "prototype", which makes unloaded elements have a
                // temporary representation while loading occurs :)
                prototypeItem:
                    Container(padding: EdgeInsets.all(8.0), child: ListTile()),

                // each song will appear as one of these widgets
                itemBuilder: (BuildContext context, int index) {
                  // grab the song
                  Song song = songs[index];

                  // return its info in this container :D
                  return Container(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        // the leading elem is the album cover.
                        //
                        // we cache it to reduce load times in large playlists
                        leading: () {
                          if (song.art != null) {
                            return CachedNetworkImage(
                                imageUrl: song.art!,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error));
                          } else {
                            return null;
                          }
                        }(),

                        // title, subtile are song's title + artist
                        title: Text(song.title),
                        subtitle: Text(song.artist),

                        // then we also provide a 'more' button.
                        //
                        // TODO(bray): allow user to specify options
                        trailing: IconButton(
                            icon: Icon(Icons.more_vert), onPressed: () => ()),
                      ));
                })));
  }
}

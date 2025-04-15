import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_mobile_flutter/models/now_playing_model.dart';
import '../types.dart';

class PlayerBar extends StatelessWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXME(bray): we'll need to access the NowPlayingModel each time we
    // render D:
    Song? song =
        Provider.of<NowPlayingModel>(context, listen: false).nowPlaying;

    // we're invisible when no song is playing
    if (song == null) {
      return const SizedBox.shrink();
    }

    // otherwise, we're a small bar straight outta spotify...
    return Material(
      // add an "inkwell" to make the cool tapping animations work
      child: SizedBox(
        height: 56,
        child: InkWell(
            onTap: () => log("show the music player subroute"),
            child: Row(children: [
              // show the album art
              if (song.art != null)
                CachedNetworkImage(
                  imageUrl: song.art!,
                )
              else
                Placeholder(),

              // title and artist
              Column(children: [
                Text(song.title, maxLines: 1),
                Text(song.artist, maxLines: 1),
              ]),

              // on the right side, show a skip icon

              // and a pause/play icon
              Consumer<NowPlayingModel>(builder: (context, info, child) {
                Icon icon;

                if (info.paused == Playback.paused) {
                  icon = Icon(Icons.pause);
                } else {
                  icon = Icon(Icons.play_arrow);
                }

                return IconButton(
                  icon: icon,
                  onPressed: () {},
                );
              })
            ])),
      ),
    );
  }
}

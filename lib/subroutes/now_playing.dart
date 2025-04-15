import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/now_playing_model.dart';
import '../types.dart';

class NowPlayingPage extends StatelessWidget {
  const NowPlayingPage({super.key});

  final String title = "Now Playing";
  static final String route = "now_playing";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      // add playback stuff here
      body: Center(
        child:
            // giant album art
            Consumer<NowPlayingModel>(
          builder: (context, info, child) {
            Song? song = info.nowPlaying;

            return Column(
              children: [
                // giant album art
                () {
                  if (song != null && song.art != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: song.art!,
                        width: 256,
                        height: 256,
                      ),
                    );
                  } else {
                    return Placeholder(fallbackWidth: 48, fallbackHeight: 48);
                  }
                }(),

                // title
                Text(song?.title ?? "Not playing"),

                // artist
                Text(song?.artist ?? "Unknown artist"),

                // controls
                Row(
                  children: [
                    // shuffle
                    IconButton(
                      icon: () {
                        if (info.shuffle == Shuffle.on) {
                          return Icon(Icons.shuffle_on);
                        } else {
                          return Icon(Icons.shuffle);
                        }
                      }(),
                      onPressed: () => info.toggleShuffle(),
                    ),

                    // skip back
                    IconButton(
                      icon: Icon(Icons.skip_previous),
                      onPressed: () => info.skipBack(),
                    ),

                    // play
                    IconButton.filled(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () => info.skipBack(),
                    ),

                    // skip next
                    IconButton(
                      icon: Icon(Icons.skip_next),
                      onPressed: () => info.skipNext(),
                    ),

                    // repeat
                    IconButton(
                      icon: () {
                        switch (info.repeat) {
                          case RepeatSetting.queue:
                            return Icon(Icons.repeat_on);
                          case RepeatSetting.single:
                            return Icon(Icons.repeat_one);
                          case RepeatSetting.off:
                            return Icon(Icons.repeat);
                        }
                      }(),
                      onPressed: () => info.nextRepeatMode(),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

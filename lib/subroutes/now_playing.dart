import 'dart:math';

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
              mainAxisSize: MainAxisSize.min,
              children: [
                // giant album art
                () {
                  double imgSize = min(MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height * 0.6);

                  if (song != null && song.art != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: song.art!,
                        width: imgSize,
                        height: imgSize,
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  } else {
                    return Placeholder(
                        fallbackWidth: imgSize, fallbackHeight: imgSize);
                  }
                }(),

                const SizedBox(height: 12),

                // title
                Text(
                  song?.title ?? "Not playing",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                // artist
                Text(
                  song?.artist ?? "Unknown artist",
                  style: Theme.of(context).textTheme.labelLarge,
                ),

                const SizedBox(height: 48),

                // slider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Consumer<NowPlayingModel>(
                    builder: (context, model, child) {
                      return Column(
                        children: [
                          Slider(
                            value: model.progress ?? 0.0,
                            max: 1.0,
                            onChanged: (value) {
                              if (model.progress != null) {
                                model.seek(model.progress!);
                              }
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _timeText(model.currentTime ?? Duration.zero),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  _timeText(Duration(
                                      seconds:
                                          model.nowPlaying?.lengthSeconds ??
                                              0)),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4.0,
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
                      iconSize: 32.0,
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

                // extra spacing to make it further from the bottom
                const SizedBox(height: 48),
              ],
            );
          },
        ),
      ),
    );
  }

  String _timeText(Duration duration) {
    // min, seconds
    String m = duration.inMinutes.remainder(60).toString().padLeft(1, '0');
    String s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    // text with that
    return "$m:$s";
  }
}

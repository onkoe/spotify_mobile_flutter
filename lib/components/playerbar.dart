import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_mobile_flutter/models/now_playing_model.dart';
import 'package:spotify_mobile_flutter/subroutes/now_playing.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Material(
            // give it a bg color
            color: Theme.of(context).colorScheme.surfaceContainer,

            // add an "inkwell" to make the cool tapping animations work

            child: SizedBox(
              height: 64,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NowPlayingPage(),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),

                    // show the album art
                    if (song.art != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: song.art!,
                          width: 48,
                          height: 48,
                        ),
                      )
                    else
                      Placeholder(fallbackWidth: 48, fallbackHeight: 48),

                    // space out the title/artist + art
                    const SizedBox(width: 12),

                    // title and artist
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            song.artist,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),

                    // add another row, but aligned to the right
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          // show a skip icon

                          // and a pause/play icon
                          Consumer<NowPlayingModel>(
                              builder: (context, info, child) {
                            Icon icon;

                            if (info.paused == Playback.paused) {
                              icon = Icon(Icons.play_arrow);
                            } else {
                              icon = Icon(Icons.pause);
                            }

                            return IconButton(
                              icon: icon,
                              onPressed: () {},
                            );
                          })
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

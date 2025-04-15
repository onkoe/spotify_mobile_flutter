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
    //
    // TODO(bray): implement
    return Material();
  }
}

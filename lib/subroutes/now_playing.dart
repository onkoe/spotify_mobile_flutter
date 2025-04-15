import 'package:flutter/material.dart';

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
        child: Column(
          children: [
            // giant album art

            // title

            // artist

            // controls
            Row(
              children: [
                // shuffle

                // skip back

                // play

                // skip next

                // repeat
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../components/navbar.dart';
import '../types.dart';

class RecentListeningPage extends StatefulWidget {
  const RecentListeningPage({super.key});

  final String title = "Recent Listening";
  static final String route = "recent";

  @override
  State<RecentListeningPage> createState() => _RecentListeningPageState();
}

class _RecentListeningPageState extends State<RecentListeningPage> {
  List<Song> recentSongs = List<Song>.empty();

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
            const Text("recent"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => (), // TODO: make this filter lol
        tooltip: "Search your recent songs",
        child: const Icon(Icons.search),
      ),

      // nav bar
      bottomNavigationBar: BottomNavigation(
          currentRoute: RecentListeningPage.route, onRouteChanged: (s) => ()),
    );
  }
}

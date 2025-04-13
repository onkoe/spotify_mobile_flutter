import 'package:flutter/material.dart';

import '../components/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String title = "Home";
  static final String route = "home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            const Text('You have pushed the button this many times:'),
          ],
        ),
      ),

      // nav bar
      bottomNavigationBar: BottomNavigation(
          currentRoute: HomePage.route, onRouteChanged: (s) => ()),
    );
  }
}

/// creates a horizontal list for the home page.
Container makeHozList(
    BuildContext context, List<Widget> listElements, String title) {
  return Container(
    margin: const EdgeInsets.all(8.0),
    padding: const EdgeInsets.all(16.0),
    // padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
        // padding between each element
        spacing: 4.0,

        // children widgets
        children: [
          // title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextTheme.of(context).titleLarge,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.left,
            ),
          ),

          // hoz. list of the media collections
          SizedBox(
            height: 128,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: listElements,
            ),
          ),
        ]),
  );
}

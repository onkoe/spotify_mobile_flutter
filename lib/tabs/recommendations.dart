import 'package:flutter/material.dart';

import '../components/navbar.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  final String title = "Recommendations";
  static final String route = "recommendations";

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
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
            const Text("recommendations"),
          ],
        ),
      ),

      // nav bar
      bottomNavigationBar: BottomNavigation(
          currentRoute: RecommendationsPage.route, onRouteChanged: (s) => ()),
    );
  }
}

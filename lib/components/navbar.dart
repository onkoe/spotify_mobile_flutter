import 'package:flutter/material.dart';

/// Returns the navbar...
void navbar() {}

class BottomNavigation extends StatelessWidget {
  final String currentRoute;
  final Function(String) onRouteChanged;

  const BottomNavigation({
    super.key,
    required this.currentRoute,
    required this.onRouteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _getIndexFromRoute(currentRoute),
      onDestinationSelected: (index) {
        final route = _getRouteFromIndex(index);
        onRouteChanged(route);
        Navigator.of(context).pushReplacementNamed(route);
      },
      destinations: _destinations(),
    );
  }

  /// a list of all the buttons on the navbar
  List<Widget> _destinations() => const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.recommend_outlined),
          selectedIcon: Icon(Icons.recommend),
          label: 'For You',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Search',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'Recent',
        ),
        NavigationDestination(
          icon: Icon(Icons.library_music_outlined),
          selectedIcon: Icon(Icons.library_music),
          label: 'Library',
        ),
      ];

  int _getIndexFromRoute(String route) {
    switch (route) {
      case "home":
        return 0;
      case "recommendations":
        return 1;
      case "search":
        return 2;
      case "recent":
        return 3;
      case "library":
        return 4;
      default:
        return 0;
    }
  }

  String _getRouteFromIndex(int index) {
    switch (index) {
      case 0:
        return "home";
      case 1:
        return "recommendations";
      case 2:
        return "search";
      case 3:
        return "recent";
      case 4:
        return "library";
      default:
        return "home";
    }
  }
}

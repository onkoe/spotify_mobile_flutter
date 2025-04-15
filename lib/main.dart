import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:provider/provider.dart';
import 'package:spotify_mobile_flutter/components/customscroll.dart';
import 'package:spotify_mobile_flutter/models/library_model.dart';
import 'package:spotify_mobile_flutter/models/now_playing_model.dart';
import 'package:spotify_mobile_flutter/tabs/library.dart';
import 'package:spotify_mobile_flutter/tabs/recent.dart';
import 'package:spotify_mobile_flutter/tabs/recommendations.dart';
import 'package:spotify_mobile_flutter/tabs/search.dart';

import 'tabs/home.dart';

Future<void> main() async {
  // run the app with our global state
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LibraryModel()),
      ChangeNotifierProvider(create: (context) => NowPlayingModel()),
    ],
    child: const SpotifyApp(),
  ));
}

class SpotifyApp extends StatelessWidget {
  const SpotifyApp({super.key});

  static const _defaultSeedColor = Color.fromRGBO(30, 215, 96, 1.0);

  static final _defaultLightColorScheme =
      ColorScheme.fromSeed(seedColor: _defaultSeedColor);

  static final _defaultDarkColorScheme = ColorScheme.fromSeed(
      seedColor: _defaultSeedColor, brightness: Brightness.dark);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TODO: decide if we want to use Spotify's colors, or adhere to Material
    // You instead.
    //
    // M3 is already a nice upgrade, but i prefer Material You on all my apps.
    //
    // might be worth making a setting for it?
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
          // titlebar/app title
          title: "definitely Spotify",

          // use the system theme mode (light/dark)
          themeMode: ThemeMode.system,

          // light theme
          theme: ThemeData(
            colorScheme: _defaultLightColorScheme,
            useMaterial3: true,
          ),

          // dark theme
          darkTheme: ThemeData(
            colorScheme: _defaultDarkColorScheme,
            useMaterial3: true,
          ),

          // adjust scroll behavior on pc (i.e. click n drag, etc.)
          scrollBehavior: EasyScrollBehavior(),

          // home page
          home: const HomePage(),

          // define all routes here
          routes: {
            "home": (BuildContext context) => const HomePage(),
            "recommendations": (context) => const RecommendationsPage(),
            "search": (context) => const SearchPage(),
            "recent": (context) => const RecentListeningPage(),
            "library": (context) => const LibraryPage(),
          });
    });
  }
}

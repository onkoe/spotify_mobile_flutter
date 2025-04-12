import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'tabs/home.dart';

Future<void> main() async {
  runApp(const SpotifyApp());
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
          title: 'Flutter Demo',

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

          // home page
          home: const HomePage(title: 'Flutter Demo Home Page'),

          // define all routes here
          routes: const {});
    });
  }
}

import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

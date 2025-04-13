import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/navbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  final String title = "Search";
  static final String route = "search";

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // inside the app bar, we'll have the back button, search bar, and a
      // voice search button.
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 10.0 + 10.0),
        child: Container(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: AppBar(
                  clipBehavior: Clip.none,

                  // use a chill color for the app bar here
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerLow,
                  elevation: 0,

                  // and for the status bar (on mobile)
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor:
                        Theme.of(context).colorScheme.surfaceContainerLow,
                  ),

                  // the "title" is actually the search bar here.
                  //
                  // dang, really wish i could do that in Figma lmao
                  title: SearchBar(
                      controller: _searchController,

                      // ask the search bar to automatically focus itself
                      autoFocus: true,

                      // show that 'clear text' button, but only if we have text.
                      //
                      // otherwise, use voice search icon
                      trailing: [
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _searchController,
                          builder: (context, value, child) {
                            if (value.text.isNotEmpty) {
                              return IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _searchController.clear();
                                  });
                            } else {
                              return IconButton(
                                  icon: const Icon(Icons.mic),
                                  onPressed: () {
                                    // TODO(bray): voice search
                                  });
                            }
                          },
                        )
                      ],
                      hintText: "What do you want to listen to?")),
            )),
      ),

      // add the results

      // the body is composed of all the results lol
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text("search"),
          ],
        ),
      ),

      // i went back on this, it's just easier for now!
      //
      // nav bar...
      bottomNavigationBar: BottomNavigation(
          currentRoute: SearchPage.route, onRouteChanged: (s) => ()),
    );
  }
}

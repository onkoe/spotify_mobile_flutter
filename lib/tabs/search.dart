import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_mobile_flutter/components/songlist.dart';

import '../components/navbar.dart';
import '../types.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  final String title = "Search";
  static final String route = "search";

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Song> _results = List.empty(growable: true);

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
                      onChanged: (value) {
                        setState(() {
                          if (value.trim().isNotEmpty) {
                            // fake search results (this aint a db, buddy)
                            _results = [
                              Song(
                                artist: "Jack Johnson",
                                title: "Upside Down",
                                lengthSeconds: (3 * 60) + 29,
                                albumName: "Upside Down",
                                art:
                                    "https://lastfm.freetls.fastly.net/i/u/770x0/db318f87093a2079aad4a00665fe2b78.jpg#db318f87093a2079aad4a00665fe2b78",
                              ),
                              Song(
                                artist: "Taylor Swift",
                                title: "Wildest Dreams",
                                lengthSeconds: (3 * 60) + 40,
                                albumName: "1989",
                                art: "https://picsum.photos/2000/2000",
                              ),
                              Song(
                                artist: "Adele",
                                title: "Hello",
                                lengthSeconds: (4 * 60) + 55,
                                albumName: "25",
                                art: "https://picsum.photos/id/10/2000",
                              ),
                              Song(
                                artist: "The Weeknd",
                                title: "Blinding Lights",
                                lengthSeconds: (3 * 60) + 20,
                                albumName: "After Hours",
                                art: "https://picsum.photos/id/20/2000",
                              ),
                              Song(
                                artist: "Billie Eilish",
                                title: "Bad Guy",
                                lengthSeconds: (3 * 60) + 14,
                                albumName:
                                    "When We All Fall Asleep, Where Do We Go?",
                                art: "https://picsum.photos/id/30/2000",
                              ),
                            ];
                          } else {
                            _results = [];
                          }
                        });
                      },

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
            SizedBox(height: 12),

            // add results
            () {
              if (_results.isEmpty) {
                return Center(
                    child: Column(children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  Text("Search for anything!"),
                ]));
              } else {
                return SongList(songs: _results);
              }
            }()
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

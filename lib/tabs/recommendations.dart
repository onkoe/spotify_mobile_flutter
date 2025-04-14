import 'package:flutter/material.dart';
import '../components/navbar.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  final String title = "Recommendations";
  static const String route = "recommendations";

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  
  final List<Map<String, String>> topPicks = [
    { "title": "Get Up Mix!", "imageUrl": "assets/images/get_up_mix.jpg"},
    { "title": "Chill Electronic Vibes", "imageUrl": "assets/images/chill_electronic.jpg"},
    { "title": "Feel Good Station", "imageUrl": "assets/images/feel_good.jpg"},
    { "title": "1989 (Taylor's Version)", "imageUrl": "assets/images/feel_good.jpg"},
    { "title": "Discovery Station", "imageUrl": "assets/images/feel_good.jpg"},
    { "title": "Drake & Similiar Artists Station", "imageUrl": "assets/images/feel_good.jpg"},
  ];

  final List<Map<String, String>> recentlyPlayed = [
    {"title": "Mozart - The 50 Best C...", "imageUrl": "https://picsum.photos/seed/mozart/150"},
    {"title": "Lemonade - Beyonce", "imageUrl": "https://picsum.photos/seed/beyonce/150"},
    {"title": "DeBi TiRAR MaS FOToS - Bad Bunny", "imageUrl": "https://picsum.photos/seed/badbunny/150"},
    {"title": "4 Kampe II - Joe Dwet & File & Burna Boy", "imageUrl": "https://picsum.photos/seed/joedwet/150"},
  ];

  final List<Map<String, String>> newReleases = [
    {"title": "More Chaos - Ken Carson", "imageUrl": "https://picsum.photos/seed/kencarson/150"},
    {"title": "Bout U (Single) - Rema", "imageUrl": "https://picsum.photos/seed/rema/150"},
    {"title": "EGO (Single) - Nemzzz", "imageUrl": "https://picsum.photos/seed/nemzzz/150"},
    {"title": "BlownBoy RU - Ruger", "imageUrl": "https://picsum.photos/seed/ruger/150"},
    {"title": "Show Me Love (Single) - WizTheMc & bees & honey", "imageUrl": "https://picsum.photos/seed/wizthemc/150"},
  ];

  final List<Map<String, String>> exploreNewAfricanMusic = [
    {"title": "Afro-Soul Mix", "imageUrl": "https://picsum.photos/seed/afrosoul/150"},
    {"title": "Ruger Essentials", "imageUrl": "https://picsum.photos/seed/rugeressentials/150"},
    {"title": "Afro-Fusion", "imageUrl": "https://picsum.photos/seed/afrofusion/150"},
    {"title": "For Broken Ears - Tems", "imageUrl": "https://picsum.photos/seed/tems/150"},
    {"title": "Burna Boy: Love Songs", "imageUrl": "https://picsum.photos/seed/burnaboylove/150"},
  ];


  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildItemBox(Map<String, String> item) {
    return Container(
      width: 150.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
         // print("Tapped on ${item['title']}");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.network(
                  item['imageUrl']!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.music_note, size: 40)),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item['title']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListItem(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            item['title']!,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }


  Widget buildHorizontalItemList(List<Map<String, String>> items) {
    return SizedBox(
      height: 180.0, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, index) {
          return buildItemBox(items[index]);
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildSectionTitle("Top Picks For You"),
            buildHorizontalItemList(topPicks),
            buildSectionTitle("Recently Played"),
            buildHorizontalItemList(recentlyPlayed),
            buildSectionTitle("New Releases"),
            buildHorizontalItemList(newReleases),
            buildSectionTitle("Explore New African Music"),
            buildHorizontalItemList(exploreNewAfricanMusic),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
          currentRoute: RecommendationsPage.route, onRouteChanged: (_) {}),
    );
  }
}
//! This file is just a screen to add a new playlist to your library.

import 'package:flutter/material.dart';

class AddPlaylistPage extends StatelessWidget {
  const AddPlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new playlist'),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Text('TODO'),
      ),
    );
  }
}

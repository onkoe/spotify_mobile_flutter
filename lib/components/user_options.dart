//! This file has the user options dialog.
//!
//! It redirects to the Settings and Account Management pages when requested by a user.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserOptionsDialog extends StatelessWidget {
  const UserOptionsDialog({super.key});

  static final String route = "user_options_dialog";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // don't become obnoxiously long in a horizontal view, or on large
      // displays
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),

      child: Container(
        constraints: const BoxConstraints(maxWidth: 360, minWidth: 240),
        child: Stack(
          children: [
            // put a close button in the top right
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // stick down a container
            _makeContainer(context),
          ],
        ),
      ),
    );
  }

  /// a container with various redirections for user's options
  Widget _makeContainer(BuildContext context) {
    return ClipRect(
      child: Column(
        // make the column not take up 234068 miles of space
        mainAxisSize: MainAxisSize.min,

        // show these subcomponents
        children: [
          // user pfp, name, and account status
          Container(
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(36),
                child: CachedNetworkImage(
                  imageUrl: "https://avatars.githubusercontent.com/u/66580279",
                ),
              ),
            ),
          ),

          Text(
            "Barrett Ray",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Row(
            // align to middle
            mainAxisAlignment: MainAxisAlignment.center,

            // space the two out
            spacing: 2.0,

            // put shiny icon + premium text
            children: [
              Icon(Icons.verified),
              Text(
                "Premium Member",
                style: Theme.of(context).textTheme.labelLarge,
              )
            ],
          ),

          // divider line
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 4),
            child: Divider(
              indent: 128,
              endIndent: 128,
            ),
          ),

          // lower buttons
          ListTile(
            title: const Text("Membership info"),
            subtitle: const Text("Thanks for being a Spotify Premium member!"),
            leading: Icon(Icons.verified),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: const Text("Manage account"),
            subtitle: const Text("Secure and manage your account"),
            leading: Icon(Icons.shield),
            trailing: Icon(Icons.open_in_new),
          ),
          ListTile(
            title: const Text("App settings"),
            subtitle: const Text("Control how Spotify works for you"),
            leading: Icon(Icons.settings),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: const Text("Sign out"),
            subtitle: const Text("Securely sign out of Spotify"),
            leading: Icon(Icons.exit_to_app),
          ),

          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 4),
            child: Divider(
              indent: 128,
              endIndent: 128,
            ),
          ),

          AboutListTile(
              icon: Icon(Icons.question_mark),
              aboutBoxChildren: [
                Text(
                  """
Created by Samuel Imose and Barrett Ray for the CS 4063-001 (Human Computer Interfaces) course at the University of Oklahoma in early 2025.

This project is distributed under the MIT License.
              """,
                )
              ],
              applicationLegalese:
                  """Spotify, the Spotify logo, and other components that may feature in this application are registered trademarks of Spotify, Inc. This project only serves as an educational to demonstrate a new take on the Spotify app's existing user interface.

No infringement is intended. All rights reserved."""),

          // add some space before the bottom
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

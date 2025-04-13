import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EasyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,

        // note: this isn't good/default behavior in normal desktop apps, as
        // it makes it very difficult to select text in textboxes that exist in
        // scrollable containers!
        //
        // however, this is a mobile app, so testing using drag is important.
        //
        // for more information on this choice, please see the Flutter Docs
        // page on the matter:
        //
        // https://docs.flutter.dev/release/breaking-changes/default-scroll-behavior-drag
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

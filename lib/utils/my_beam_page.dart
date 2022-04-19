import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';

class MyBeamPage extends BeamPage {
  MyBeamPage({required Widget child, required String title, bool showHeaderNavbarAndSidebar = true})
      : super(
          child: child,
          title: title,
          type: BeamPageType.noTransition,
          key: ValueKey(title),
        );
}

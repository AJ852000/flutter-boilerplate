import 'package:app_links/app_links.dart';

import 'package:go_router/go_router.dart';

void initAppLinks(GoRouter router) {
  final applinks = AppLinks();

  applinks.uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      print('AppLink received: $uri');

      // Remove GitHub Pages repo prefix
      final path = uri.path.replaceFirst('/flutter-boilerplate', '');

      if (path.isNotEmpty) {
        router.go(path); // Navigate to GoRouter route
      }
    }
  });
}

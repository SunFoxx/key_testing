import 'package:flutter/cupertino.dart';
import 'package:key_testing/scenes/welcome_page/welcome_page.dart';

import 'dashboard/dashboard.dart';
import 'initial_scene.dart';

/// class with static methods that adapt [Navigator] for the app's needs
class NavigationHandler {
  static Future push(
    BuildContext context,
    String routeName, [
    NavigationPayload payload = NavigationPayload.defaultPayload,
  ]) async {
    return await Future(() {
      Navigator.of(context).pushNamedAndRemoveUntil(
        routeName,
        (route) => (routeName == route.settings.name && route.isCurrent),
        arguments: payload,
      );
    });
  }

  static Future pushReplacement(
    BuildContext context,
    String routeName, [
    NavigationPayload payload = NavigationPayload.defaultPayload,
  ]) async {
    return Future(() {
      Navigator.of(context, rootNavigator: true)
          .pushReplacementNamed(routeName, arguments: payload);
    });
  }

  /// completely reduce the whole navigation to the selected route
  static Future resetTo(
    BuildContext context,
    String routeName, [
    NavigationPayload payload = NavigationPayload.defaultPayload,
  ]) async {
    return await Future(() {
      Navigator.of(context).pushNamedAndRemoveUntil(
        routeName,
        (route) => !(routeName == route.settings.name && route.isCurrent),
        arguments: NavigationPayload(
          showCupertinoAnimation: false,
          slideFrom: Offset(-3.0, 0.0),
        ),
      );
    });
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    NavigationPayload payload = (settings.arguments as NavigationPayload) ??
        NavigationPayload.defaultPayload;

    if (!payload.showCupertinoAnimation) {
      return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context, a1, a2) {
          return _buildRouteByName(context, settings.name);
        },
        transitionsBuilder: (context, a1, a2, child) {
          var slide = Tween<Offset>(
            begin: payload.slideFrom,
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: a1,
              curve: Curves.easeOut,
            ),
          );

          return SlideTransition(
            position: slide,
            child: child,
          );
        },
      );
    }

    return CupertinoPageRoute(
      maintainState: false,
      builder: (context) => _buildRouteByName(context, settings.name),
    );
  }

  static Widget _buildRouteByName(BuildContext context, String routeName) {
    switch (routeName) {
      case InitialScene.routeName:
        return InitialScene();
      case WelcomePage.routeName:
        return WelcomePage();
      case DashboardScene.routeName:
        return DashboardScene();
      default:
        return Center(
          child: Text("404 route"),
        );
    }
  }
}

/// unified configuration for route transitions
/// set [showCupertinoAnimation] to [false] to make custom behaviour work
class NavigationPayload {
  final bool showCupertinoAnimation;
  final Offset slideFrom;

  static const defaultPayload = const NavigationPayload(
    showCupertinoAnimation: true,
    slideFrom: Offset.zero,
  );

  const NavigationPayload({
    this.showCupertinoAnimation = true,
    this.slideFrom = Offset.zero,
  });
}

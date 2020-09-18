import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_testing/provider/auth_provider.dart';
import 'package:key_testing/provider/overlay_provider.dart';
import 'package:key_testing/scenes/dashboard.dart';
import 'package:key_testing/scenes/initial_scene.dart';
import 'package:key_testing/scenes/welcome_page/welcome_page.dart';
import 'package:key_testing/widgets/overlay/notifications_layer.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providers,
      builder: (context, child) {
        return Stack(
          textDirection: TextDirection.ltr,
          children: [
            CupertinoApp(
              debugShowCheckedModeBanner: false,
              initialRoute: InitialScene.routeName,
              onGenerateRoute: _onGenerateRoute,
            ),
            NotificationsLayer(),
          ],
        );
      },
    );
  }

  List<SingleChildWidget> get _providers => [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ];

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    if (settings.name == WelcomePage.routeName) {
      return PageRouteBuilder(
        pageBuilder: (context, a1, a2) {
          return WelcomePage();
        },
      );
    }

    return CupertinoPageRoute(
      maintainState: false,
      builder: (context) {
        switch (settings.name) {
          case InitialScene.routeName:
            return InitialScene();
          case DashboardScene.routeName:
            return DashboardScene();
          default:
            return Center(
              child: Text("404 route"),
            );
        }
      },
    );
  }
}

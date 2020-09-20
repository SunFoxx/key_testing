import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:key_testing/provider/auth_provider.dart';
import 'package:key_testing/scenes/dashboard.dart';
import 'package:key_testing/scenes/navigation.dart';
import 'package:key_testing/scenes/welcome_page/welcome_page.dart';
import 'package:key_testing/widgets/background.dart';
import 'package:provider/provider.dart';

/// Used as a splash screen while also managing initial state of the app
class InitialScene extends StatefulWidget {
  static const routeName = '/';

  @override
  _InitialSceneState createState() => _InitialSceneState();
}

class _InitialSceneState extends State<InitialScene> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_postFrameCallback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(blur: 10);
  }

  void _postFrameCallback(timestamp) async {
    await Future.wait([
      Firebase.initializeApp(),
    ]);

    AuthProvider authState = Provider.of<AuthProvider>(context, listen: false);
    String routeDestination = authState.isAuthorized
        ? DashboardScene.routeName
        : WelcomePage.routeName;

    await NavigationHandler.push(
      context,
      routeDestination,
      NavigationPayload(showCupertinoAnimation: false),
    );
  }
}

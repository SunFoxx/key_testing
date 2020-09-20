import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_testing/provider/auth_provider.dart';
import 'package:key_testing/provider/notifications_layer_provider.dart';
import 'package:key_testing/scenes/initial_scene.dart';
import 'package:key_testing/scenes/navigation.dart';
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
              onGenerateRoute: NavigationHandler.onGenerateRoute,
            ),
            NotificationsLayer(),
          ],
        );
      },
    );
  }

  List<SingleChildWidget> get _providers => [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsLayerProvider()),
      ];
}

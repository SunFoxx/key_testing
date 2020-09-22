import 'package:flutter/cupertino.dart';
import 'package:key_testing/theme/colors.dart';
import 'package:key_testing/widgets/user_info.dart';

class DashboardScene extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _DashboardSceneState createState() => _DashboardSceneState();
}

class _DashboardSceneState extends State<DashboardScene> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: UserInfo(),
            ),
          ],
        ),
      ),
    );
  }
}

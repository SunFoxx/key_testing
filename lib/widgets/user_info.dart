import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:key_testing/provider/auth_provider.dart';
import 'package:key_testing/scenes/navigation.dart';
import 'package:key_testing/scenes/welcome_page/welcome_page.dart';
import 'package:key_testing/theme/colors.dart';
import 'package:key_testing/theme/typografy.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<AuthProvider, User>(
      selector: (_, authState) => authState.authorizedUser,
      builder: (_, user, child) {
        return Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary05,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      "🦊️",
                      style: TextStyle(fontSize: 42.0),
                    ),
                  ),
                  CupertinoButton(
                    child: Text(
                      "Выйти",
                      style: AppTextStyles.buttonTextStyle,
                    ),
                    onPressed: () => _onLogOutPressed(context),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onLogOutPressed(BuildContext context) async {
    await NavigationHandler.resetTo(context, WelcomePage.routeName);
    AuthProvider().logOut();
  }
}

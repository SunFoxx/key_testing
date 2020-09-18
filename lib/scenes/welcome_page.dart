import 'package:flutter/cupertino.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:key_testing/provider/auth_provider.dart';
import 'package:key_testing/services/firebase_auth.dart';
import 'package:key_testing/theme/colors.dart';
import 'package:key_testing/theme/typografy.dart';
import 'package:key_testing/widgets/background.dart';
import 'package:key_testing/widgets/loader_overlay.dart';
import 'package:key_testing/widgets/text_input.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  static const String routeName = 'welcome_page';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static const double _topBarHeight = 150.0;

  String _login = "";
  String _password = "";

  bool _isRegistration = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Background(blur: 1)),
        FocusWatcher(
          liftOffset: 30,
          child: CupertinoPageScaffold(
            backgroundColor: AppColors.transparent,
            resizeToAvoidBottomInset: false,
            child: Consumer<AuthProvider>(
              builder: (context, authState, child) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: _topBarHeight,
                          alignment: Alignment.center,
                          color: AppColors.primary,
                          child: Text(
                            "Ключ",
                            style: AppTextStyles.logoStyle,
                          ),
                        ),
                        Expanded(
                          child: _buildAuthContainer(context, authState),
                        ),
                      ],
                    ),
                    LoaderOverlay(isLoading: authState.isLoading),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthContainer(BuildContext context, AuthProvider authState) {
    var maxWidth = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      child: Container(
        width: maxWidth * 0.8,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isRegistration ? "Регистрация" : "Авторизация",
              style: AppTextStyles.primaryFont,
            ),
            TextInput(
              label: "Логин",
              onChanged: _onLoginEdited,
            ),
            TextInput(
              label: "Пароль",
              onChanged: _onPasswordEdited,
              isObscure: true,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: CupertinoButton(
                child: Text(
                  "ВОЙТИ",
                  style: AppTextStyles.buttonTextStyle,
                ),
                color: AppColors.focus,
                onPressed: () => _onLoginPressed(authState),
              ),
            ),
            CupertinoButton(
              child: Text(
                "Регистрация",
                style: AppTextStyles.focusedTextStyle,
              ),
              onPressed: _switchSigningType,
            ),
            CupertinoButton(
              child: Text(
                "Kill user: ${authState.authorizedUser?.uid}",
                style: AppTextStyles.focusedTextStyle,
              ),
              onPressed: () {
                FirebaseAuthService.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onLoginPressed(AuthProvider state) async {
    var result = await state.onAuth(_login, _password);
  }

  void _onLoginEdited(String val) {
    setState(() {
      _login = val;
    });
  }

  void _onPasswordEdited(String val) {
    setState(() {
      _password = val;
    });
  }

  void _switchSigningType() {
    setState(() {
      _isRegistration = !_isRegistration;
    });
  }
}

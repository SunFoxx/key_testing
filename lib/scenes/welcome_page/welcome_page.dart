import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:key_testing/provider/auth_provider.dart';
import 'package:key_testing/provider/notifications_layer_provider.dart';
import 'package:key_testing/scenes/dashboard/dashboard.dart';
import 'package:key_testing/scenes/navigation.dart';
import 'package:key_testing/theme/colors.dart';
import 'package:key_testing/theme/typografy.dart';
import 'package:key_testing/widgets/background.dart';
import 'package:key_testing/widgets/loader_overlay.dart';
import 'package:key_testing/widgets/text_input.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  static const String routeName = '/welcome_page';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  static const double _topBarHeight = 150.0;

  String _login = "";
  String _password = "";
  String _repeatPassword = "";

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
                        Expanded(child: _buildCardContent(context, authState)),
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

  Widget _buildCardContent(BuildContext context, AuthProvider authState) {
    double maxWidth = MediaQuery.of(context).size.width;

    List<Widget> stepChildren = (authState.isAwaitingForEmailVerification)
        ? _buildEmailConfirmationContent(context, authState)
        : _buildAuthContent(context, authState);

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stepChildren,
        ),
      ),
    );
  }

  List<Widget> _buildAuthContent(
          BuildContext context, AuthProvider authState) =>
      [
        Text(
          _isRegistration ? "Регистрация" : "Авторизация",
          style: AppTextStyles.primaryFont,
        ),
        TextInput(
          label: "@ Email",
          onChanged: _onLoginEdited,
          textInputType: TextInputType.emailAddress,
          text: _login,
        ),
        TextInput(
          label: "• Пароль",
          onChanged: _onPasswordEdited,
          isObscure: true,
          text: _password,
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          vsync: this,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 800),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            layoutBuilder: (widget, previousWidgets) {
              return Stack(
                children: <Widget>[
                  ...previousWidgets,
                  if (widget != null) Positioned(child: widget),
                ],
              );
            },
            transitionBuilder: (child, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (ctx, chld) {
                  var scale = CurvedAnimation(
                    parent: animation,
                    curve: Interval(0.35, 1.0, curve: Curves.easeOut),
                  );

                  return ScaleTransition(
                    scale: scale,
                    alignment: !_isRegistration
                        ? Alignment.topCenter
                        : Alignment.bottomCenter,
                    child: Opacity(
                      child: child,
                      opacity: animation.value,
                    ),
                  );
                },
              );
            },
            child: _isRegistration
                ? _buildRegistrationStep(authState)
                : _buildLogInStep(authState),
          ),
        ),
      ];

  List<Widget> _buildEmailConfirmationContent(
          BuildContext context, AuthProvider authState) =>
      [
        Text(
          "Подтверждение почты",
          style: AppTextStyles.primaryFont,
        ),
        SizedBox(height: 15),
        Text(
          "Перейдите по ссылке в письме, которое было отправлено на вашу почту, чтобы продолжить",
          style: AppTextStyles.inputLabelStyle,
          textAlign: TextAlign.center,
        ),
        CupertinoButton(
          child: Text(
            "Отправить повторно",
            style: AppTextStyles.focusedTextStyle,
          ),
          onPressed: () => authState.sendVerificationLink(_redirectToDashboard),
        ),
        CupertinoButton(
          child: Text(
            "Назад",
            style: AppTextStyles.focusedTextStyle,
          ),
          onPressed: _onEmailVerificationCancelled,
        ),
      ];

  Widget _buildLogInStep(AuthProvider authState) {
    return Column(
      key: Key("log_in_step"),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
      ],
    );
  }

  Widget _buildRegistrationStep(AuthProvider authState) {
    return Column(
      key: Key("registration_step"),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextInput(
          label: "•• Повторить пароль",
          onChanged: _onRepeatPasswordEdited,
          isObscure: true,
          text: _repeatPassword,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Text(
              "Зарегистрироваться",
              style: AppTextStyles.buttonTextStyle,
              maxLines: 1,
            ),
            color: AppColors.focus,
            onPressed: () => _onRegistrationPressed(authState),
          ),
        ),
        CupertinoButton(
          child: Text(
            "Назад",
            style: AppTextStyles.focusedTextStyle,
          ),
          onPressed: _switchSigningType,
        ),
      ],
    );
  }

  void _onLoginPressed(AuthProvider state) async {
    await state.logIn(_login, _password, _redirectToDashboard);
  }

  void _onRegistrationPressed(AuthProvider state) async {
    if (_password != _repeatPassword) {
      NotificationsLayerProvider().showNotification(
        NotificationElement(
            type: NotificationType.error,
            text: "Введенные пароли не совпадают",
            duration: Duration(milliseconds: 1750)),
      );

      return;
    }
    await state.register(_login, _password, _redirectToDashboard);
  }

  void _redirectToDashboard() {
    NavigationHandler.push(context, DashboardScene.routeName);
  }

  void _onEmailVerificationCancelled() async {
    await AuthProvider().logOut();
    setState(() {
      _isRegistration = false;
      _repeatPassword = "";
    });
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

  void _onRepeatPasswordEdited(String val) {
    setState(() {
      _repeatPassword = val;
    });
  }

  void _switchSigningType() {
    setState(() {
      _isRegistration = !_isRegistration;
    });
  }
}

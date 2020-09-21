import 'package:flutter/cupertino.dart';
import 'package:key_testing/model/user.dart';
import 'package:key_testing/provider/auth_provider.dart';
import 'package:key_testing/scenes/navigation.dart';
import 'package:key_testing/scenes/welcome_page/welcome_page.dart';
import 'package:key_testing/theme/colors.dart';
import 'package:key_testing/theme/typografy.dart';
import 'package:key_testing/widgets/text_input.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo>
    with SingleTickerProviderStateMixin {
  bool _isEditingName = false;
  String _newName = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, AuthProvider authState, child) {
        return AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 450),
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: _buildContent(context, authState),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AuthProvider authState) {
    var user = authState.authorizedUser;

    if (user == null) {
      return Center(
        child: CupertinoActivityIndicator(radius: 20.0),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildFirstRow(context, user),
        SizedBox(height: 15),
        _buildSecondRow(context, authState),
      ],
    );
  }

  Widget _buildFirstRow(BuildContext context, KeyUser user) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
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
          SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  user.email,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.backgroundedSmall,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
                if (user.name?.isNotEmpty == true)
                  Text(
                    user.name,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.backgroundedSmall,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  ),
              ],
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(
              "Выйти",
              style: AppTextStyles.buttonTextStyle,
            ),
            onPressed: () => _onLogOutPressed(context),
          ),
        ],
      );

  Widget _buildSecondRow(BuildContext context, AuthProvider authState) {
    Widget basePresentation = Row(
      key: Key("config_panel"),
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Админ:",
                style: AppTextStyles.buttonTextStyle,
              ),
              CupertinoSwitch(
                value: authState.authorizedUser.isAdmin,
                onChanged: (v) => _onAdminSwitch(v, authState.authorizedUser),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 25,
          margin: EdgeInsets.symmetric(horizontal: 7.5),
          color: AppColors.primary05,
        ),
        Flexible(
          child: Row(
            children: [
              Text("👤", style: TextStyle(fontSize: 30.0)),
              CupertinoButton(
                child: Text(
                  "${authState.authorizedUser.name.isEmpty ? "Задать" : "Изменить"} имя",
                  style: AppTextStyles.focusedTextStyle,
                ),
                onPressed: _nameEditSwitch,
              )
            ],
          ),
        ),
      ],
    );

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      switchInCurve: Curves.easeOut,
      child: _isEditingName ? _buildNameChanger(authState) : basePresentation,
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildNameChanger(AuthProvider state) {
    return Row(
      key: Key("name_changer"),
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: CupertinoButton(
            minSize: 40,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "Отмена",
              style: AppTextStyles.buttonTinyTextStyle,
              maxLines: 1,
            ),
            onPressed: _nameEditSwitch,
            color: AppColors.error,
          ),
        ),
        SizedBox(width: 3),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: TextInput(
            placeholder: "Введите имя",
            text: state.authorizedUser.name,
            onChanged: _onNameInputChanged,
          ),
        ),
        SizedBox(width: 3),
        Flexible(
          flex: 1,
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minSize: 40,
            child: Text(
              "Сохранить",
              style: AppTextStyles.buttonTinyTextStyle,
              maxLines: 1,
            ),
            onPressed: _nameEditSwitch,
            color: AppColors.focus,
          ),
        ),
      ],
    );
  }

  void _onAdminSwitch(bool newStatus, KeyUser user) {
    user.changeAdminRight(newStatus);
    setState(() {}); // rebuild widget
  }

  void _onNameInputChanged(String text) {
    setState(() {
      _newName = text;
    });
  }

  void _onLogOutPressed(BuildContext context) async {
    await NavigationHandler.resetTo(context, WelcomePage.routeName);
    AuthProvider().logOut();
  }

  void _nameEditSwitch() {
    setState(() {
      _isEditingName = !_isEditingName;
    });
  }
}

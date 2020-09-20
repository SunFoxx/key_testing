import 'package:flutter/cupertino.dart';
import 'package:key_testing/provider/notifications_layer_provider.dart';
import 'package:key_testing/theme/colors.dart';
import 'package:key_testing/theme/typografy.dart';
import 'package:key_testing/utils/string_utils.dart';
import 'package:provider/provider.dart';

class NotificationsLayer extends StatefulWidget {
  @override
  _NotificationsLayerState createState() => _NotificationsLayerState();
}

class _NotificationsLayerState extends State<NotificationsLayer>
    with SingleTickerProviderStateMixin {
  AnimationController _appearController;
  NotificationElement _element;

  Duration get _appearDuration => const Duration(milliseconds: 500);

  @override
  void initState() {
    _appearController = AnimationController(
      vsync: this,
      duration: _appearDuration,
    );
    _appearController.addStatusListener(_appearStatusListener);
    super.initState();
  }

  @override
  void dispose() {
    _appearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: AppColors.background,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Consumer<NotificationsLayerProvider>(
          builder: (context, state, child) {
            _element = state.activeOverlay;

            if (_element == null) return SizedBox();

            if (_element != null && _appearController.isDismissed) {
              _appearController.forward();
            }

            return SafeArea(
              child: AnimatedBuilder(
                animation: _appearController,
                builder: (context, child) {
                  var slide = Tween<Offset>(
                    begin: Offset(0, -1),
                    end: Offset(0, 0),
                  ).animate(_appearController);

                  return SlideTransition(
                    position: slide,
                    child: Container(
                      height: 70,
                      margin: EdgeInsets.all(12.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: _element.type == NotificationType.error
                                ? AppColors.error
                                : AppColors.focus,
                            spreadRadius: 2.0,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              _element.type == NotificationType.error
                                  ? getRandomErrorEmoji(_element.hashCode)
                                  : "❕",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 5,
                            child: Center(
                              child: Text(
                                _element.text,
                                style: AppTextStyles.notificationTextStyle,
                              ),
                            ),
                          ),
                          _renderCloseButton(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _renderCloseButton() {
    if ((_element?.duration?.inMilliseconds ?? 0) == 0) {
      return Flexible(
        fit: FlexFit.loose,
        child: IgnorePointer(
          ignoring: _appearController.isAnimating,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 15.0,
            child: Icon(
              CupertinoIcons.clear_thick_circled,
              size: 30.0,
              color: _element.type == NotificationType.error
                  ? AppColors.error
                  : AppColors.focus,
            ),
            onPressed: () {
              _appearController.reverse();
            },
          ),
        ),
      );
    }

    return Flexible(child: SizedBox(), fit: FlexFit.loose);
  }

  void _appearStatusListener(AnimationStatus status) {
    var autoCloseDelay = _element.duration?.inMilliseconds ?? 0;

    if (status == AnimationStatus.completed && autoCloseDelay > 0) {
      Future.delayed(
        _element.duration,
        () {
          _appearController.reverse();
        },
      );
      return;
    }

    if (status == AnimationStatus.dismissed) {
      NotificationsLayerProvider().dismissNotification();
    }
  }
}

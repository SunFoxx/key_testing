import 'package:flutter/cupertino.dart';
import 'package:key_testing/theme/colors.dart';

class LoaderOverlay extends StatelessWidget {
  static final double size = 80.0;

  final bool isLoading;

  const LoaderOverlay({Key key, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return Container();

    double padding = size * 0.05;

    return Container(
      color: AppColors.primary05.withOpacity(0.4),
      alignment: Alignment.center,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(padding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary55.withOpacity(0.8),
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: CupertinoActivityIndicator(radius: (size / 2) - (padding * 2)),
      ),
    );
  }
}

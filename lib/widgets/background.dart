import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:key_testing/theme/colors.dart';

class Background extends StatefulWidget {
  final double blur;

  const Background({
    Key key,
    this.blur = 0,
  }) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: widget.blur,
        sigmaY: widget.blur,
      ),
      child: Image.asset(
        "assets/images/background.jpeg",
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        alignment: Alignment.bottomCenter,
        colorBlendMode: BlendMode.hardLight,
        color: AppColors.primary05.withOpacity(0.3),
      ),
    );
  }
}

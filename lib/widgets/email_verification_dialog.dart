import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailVerificationDialog extends SimpleDialog {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      color: CupertinoColors.activeGreen,
    );
  }
}

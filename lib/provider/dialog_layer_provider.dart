import 'package:flutter/material.dart';

class DialogLayerProvider extends ChangeNotifier {
  static final DialogLayerProvider _instance = DialogLayerProvider._();

  factory DialogLayerProvider() => _instance;

  DialogLayerProvider._();
}

class DialogElement {
  final Key key;
  final Widget child;
  final DialogType type;
  final Function onCancel;
  final Function onFinish;

  DialogElement({
    Key key,
    @required this.child,
    @required this.type,
    this.onCancel,
    this.onFinish,
  }) : this.key = key ?? Key(DateTime.now().toString());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DialogElement &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;
}

enum DialogType {
  content,
  alert,
}

import 'package:flutter/cupertino.dart';
import 'package:key_testing/theme/colors.dart';
import 'package:key_testing/theme/typografy.dart';

class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ScrollController scrollController;
  final Function onFocus;
  final String label;
  final String text;
  final String placeholder;
  final double borderWidth;
  final bool isObscure;
  final TextInputType textInputType;
  final TextStyle textStyle;
  final TextAlign textAlign;

  TextInput({
    Key key,
    this.onChanged,
    this.label,
    this.borderWidth = 1.5,
    this.onFocus,
    this.scrollController,
    this.isObscure = false,
    this.controller,
    this.text = "",
    this.textInputType = TextInputType.text,
    this.textStyle,
    this.textAlign,
    this.placeholder,
  }) : super(key: key);

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  static double get _labelHeight => 25.0;

  bool _isFocused = false;
  FocusNode _focusNode;
  TextEditingController _controller;

  Duration get _focusTransitionDuration => Duration(milliseconds: 250);

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(_onFieldFocus);
    _controller = widget.controller ?? TextEditingController(text: widget.text);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFieldFocus);
    _focusNode.unfocus();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: widget.label != null ? _labelHeight : 0),
          child: AnimatedContainer(
            duration: _focusTransitionDuration,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: _isFocused ? AppColors.focus : AppColors.primary55,
                width: widget.borderWidth,
              ),
            ),
            child: CupertinoTextField(
              focusNode: _focusNode,
              controller: _controller,
              onChanged: widget.onChanged,
              style: widget.textStyle ?? AppTextStyles.inputTextStyle,
              textAlign: widget.textAlign ?? TextAlign.left,
              keyboardType: widget.textInputType,
              padding: const EdgeInsets.all(11.5),
              clearButtonMode: OverlayVisibilityMode.editing,
              obscureText: widget.isObscure,
              placeholder: widget.placeholder,
              placeholderStyle: AppTextStyles.inputPlaceholderTextStyle,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        if (widget.label != null) _buildLabel(),
      ],
    );
  }

  Widget _buildLabel() {
    return Positioned(
      left: 20,
      top: _labelHeight / 2,
      child: Container(
        alignment: Alignment.center,
        height: _labelHeight,
        color: AppColors.background,
        padding: EdgeInsets.only(
          left: 5.0,
          right: 3.0,
        ),
        child: AnimatedDefaultTextStyle(
          child: Text(widget.label),
          duration: _focusTransitionDuration,
          style: AppTextStyles.inputLabelStyle.copyWith(
            color: _isFocused ? AppColors.focus : AppColors.primary55,
          ),
        ),
      ),
    );
  }

  void _onFieldFocus() {
    setState(() {
      _isFocused = _focusNode.hasFocus;

      if (widget.scrollController != null) {
        widget.scrollController.jumpTo(-_labelHeight);
      }

      if (widget.onFocus != null) {
        widget.onFocus();
      }
    });
  }
}

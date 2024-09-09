import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final Icon? icon;
  final String? hintText;
  final bool isPassword;
  final bool isEmail;
  final bool isEmailField;
  final bool isPhone;
  final Icon? tempIcon;
  final String? tempHintText;
  final Function()? onTap;
  final TextEditingController _textEditingController;
  final Function(String)? validationCallback;
  bool hidePassword;
  IconData passwordIcon;
  final TextInputType textInputType;
  final String? value;
  int maxLines;

  CustomTextfield(
      this.icon,
      this.hintText,
      this.isPassword,
      this._textEditingController, {
        this.isEmail = false,
        this.onTap,
        this.isEmailField = true,
        this.isPhone = false,
        this.validationCallback,
        this.textInputType = TextInputType.text,
        this.value,
        this.maxLines = 1,
        super.key,
      })  : tempIcon = icon,
        tempHintText = hintText,
        hidePassword = isPassword,
        passwordIcon = Icons.remove_red_eye;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
    // Set the initial value of the TextEditingController if provided
    if (widget.value != null && widget.value!.isNotEmpty) {
      widget._textEditingController.text = widget.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._textEditingController,
      obscureText: widget.hidePassword,
      enableSuggestions: !widget.isPassword,
      autocorrect: !widget.isPassword,
      cursorColor: Colors.white,
      keyboardType: widget.textInputType,
      maxLines: widget.maxLines,
      style: TextStyle(
        fontFamily: 'Modernist',
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blue[50],
        hintText: "${widget.hintText}",
        prefixIcon: GestureDetector(
          child: widget.icon,
        ),
        suffixIcon: widget.hidePassword || widget.isPassword
            ? GestureDetector(
          onTap: () {
            setState(() {
              widget.hidePassword = !widget.hidePassword;
              widget.passwordIcon = widget.hidePassword
                  ? Icons.remove_red_eye
                  : Icons.hide_source;
            });
          },
          child: Icon(widget.passwordIcon),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 3.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 3.0,
          ),
        ),
        errorText: _errorText,
      ),
      validator: (value) {
        if (widget.validationCallback != null) {
          return widget.validationCallback!(value ?? '');
        }
        return null;
      },
      onChanged: (value) {
        if (widget.validationCallback != null) {
          String? validationError = widget.validationCallback!(value);
          setState(() {
            _errorText = validationError;
          });
        }
      },
    );
  }
}

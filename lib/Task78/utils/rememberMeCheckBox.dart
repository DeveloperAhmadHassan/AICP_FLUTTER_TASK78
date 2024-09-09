import 'package:flutter/material.dart';

import '../commonWidgets/custom_text.dart';
import '../controllers/authController.dart';
import '../extensions/color_ext.dart';

class RememberMe extends StatefulWidget{
  AuthController authController;
  RememberMe({required this.authController, super.key});

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.selected
      };

      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }

      return Colors.black12;
    }
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: widget.authController.rememberMe,
          onChanged: (bool? value) {
            setState(() {
              toggleCheckBox();
            });
          },
        ),
        CustomText(
          "Remember Me",
          16,
          alignment: Alignment.center,
          onTap: (){},
        ),
      ],
    );
  }

  void toggleCheckBox(){
    setState(() {
      widget.authController.rememberMe = !widget.authController.rememberMe;
    });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

import 'dataLoaders.dart';

class AlertDialogs{
  static Future<bool> showTermsAndConditionsDialog() async {
    String content = await DataLoader.loadTermsAndConditions();
    return await showDialog(
      context: Get.overlayContext!,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Terms and Conditions'),
          content: Container(
            width: double.maxFinite,
            child: Markdown(data: content),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text("I Don't", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
              )),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.green
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text('I Agree', style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
              )),
            ),
          ],
        );
      },
    );
  }
}
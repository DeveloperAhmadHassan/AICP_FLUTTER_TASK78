import 'package:aicp_internship/Task78/pages/SignInPage.dart';
import 'package:aicp_internship/Task78/pages/userPage.dart';
import 'package:aicp_internship/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'Task78/controllers/authController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController userController = Get.put(AuthController());
    return GetMaterialApp(
      title: 'Business App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Obx(() {
        return userController.isSignedIn.value ? UserPage() : const SignInPage();
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}

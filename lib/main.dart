import 'package:deepind/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/route_manager.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp(initialRoute: '/'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/', page: () => const MainPage()), 
      ],
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}


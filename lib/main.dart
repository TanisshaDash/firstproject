import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'controllers/movie_controller.dart';
import 'controllers/favorites_controller.dart';
import 'screens/home/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cinema',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialBinding: AppBindings(), // injects controllers at startup
      home: const HomeScreen(),
    );
  }
}

// Dependency Injection — replaces MultiProvider
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MovieController());
    Get.lazyPut(() => FavoritesController());
  }
}
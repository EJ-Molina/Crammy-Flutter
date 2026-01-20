import 'package:crammy_app/screens/container_home+learn/main_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing dotenv...');
  await dotenv.load();
  print('Dotenv loaded. Starting app...');
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppContainer(),
    );
  }
}
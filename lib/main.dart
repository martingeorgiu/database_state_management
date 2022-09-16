import 'package:database_state_management/services/registry.dart';
import 'package:database_state_management/ui/homepage.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

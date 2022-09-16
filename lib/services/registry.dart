import 'package:database_state_management/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final registry = GetIt.instance;

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  registry.registerSingleton<AppDatabase>(AppDatabase());
}

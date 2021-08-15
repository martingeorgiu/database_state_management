import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moor_state_management/services/database.dart';

final registry = GetIt.instance;

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  registry.registerSingleton<AppDatabase>(AppDatabase());
}

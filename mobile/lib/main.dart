import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod';
import 'package:hive_flutter/hive_flutter';

import 'app/app.dart';
import 'domain/entities/warranty_entity.dart';
import 'domain/entities/user_entity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Register adapters for local entities
  Hive.registerAdapter(WarrantyAdapter());
  Hive.registerAdapter(UserAdapter());

  // Open boxes
  await Hive.openBox<WarrantyEntity>('warranties');
  await Hive.openBox<UserEntity>('users');

  runApp(const ProviderScope(child: WarrantyApp()));
}
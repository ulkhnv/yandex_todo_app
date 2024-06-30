import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/core/config/config.dart';
import 'src/core/constants/theme/theme.dart';
import 'src/core/utils/utils.dart';
import 'src/features/tasks/presentation/pages/pages.dart';
import 'src/features/tasks/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const YandexTodoApp(),
    ),
  );
}

class YandexTodoApp extends StatelessWidget {
  const YandexTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: S.ru,
      supportedLocales: S.supportedLocales,
      localizationsDelegates: S.localizationDelegates,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const TodoListPage(),
    );
  }
}

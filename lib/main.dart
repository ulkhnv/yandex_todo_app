import 'package:flutter/material.dart';

import 'src/core/constants/theme/theme.dart';
import 'src/features/tasks/presentation/pages/pages.dart';

void main() {
  runApp(const YandexTodoApp());
}

class YandexTodoApp extends StatelessWidget {
  const YandexTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const TodoListPage(),
    );
  }
}

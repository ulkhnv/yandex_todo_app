import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../widgets/widgets.dart';
import '/src/core/utils/utils.dart';
import 'pages.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = <Task>[
      Task(id: "1", text: "Пресс качат", importance: TaskImportance.basic, done: true, ),
      Task(id: "2", text: "Бегит", importance: TaskImportance.low, done: false),
      Task(id: "3", text: "Анжуманя", importance: TaskImportance.important, done: false),

    ];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: HeaderDelegate(),
          ),
          SliverToBoxAdapter(
            child: TaskList(
              tasks: tasks,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormPage(),
            ),
          );
        },
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: context.customColors.white,
        ),
      ),
    );
  }
}

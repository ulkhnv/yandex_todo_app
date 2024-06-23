import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../widgets/widgets.dart';
import '/src/core/utils/utils.dart';
import 'pages.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    final tasks = <Task>[];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 30, bottom: 10),
              title: Text("Мои Дела", style: context.textTheme.titleLarge),
            ),
            expandedHeight: 148,
            pinned: true,
            floating: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: context.customColors.blue,
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return TaskItem(task: tasks[index]);
                      },
                      itemCount: tasks.length,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaskFormPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Новое",
                          style: context.textTheme.bodyMedium!
                              .copyWith(color: context.colorScheme.tertiary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
        child: Icon(Icons.add, color: context.customColors.white),
      ),
    );
  }
}

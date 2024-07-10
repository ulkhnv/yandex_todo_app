import 'package:flutter/material.dart';

import '../../data/models/models.dart';
import '../pages/pages.dart';
import '/src/core/utils/utils.dart';
import 'widgets.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final bool isVisible;

  const TaskList({super.key, required this.tasks, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    final visibleTasks = isVisible ? tasks : tasks.where((task) => !task.done).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return TaskItem(
                  task: visibleTasks[index],
                );
              },
              itemCount: visibleTasks.length,
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
                  context.localizations.newTask,
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: context.colorScheme.tertiary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

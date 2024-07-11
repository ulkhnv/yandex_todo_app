import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/routes.dart';
import '../../data/models/models.dart';
import '/src/core/utils/utils.dart';
import 'widgets.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final bool isVisible;

  const TaskList({super.key, required this.tasks, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    final visibleTasks =
        isVisible ? tasks : tasks.where((task) => !task.done).toList();
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
            visibleTasks.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 48.0, top: 10),
                    child: Text(
                      context.localizations.noTasks,
                      style: context.textTheme.titleMedium,
                    ),
                  )
                : ListView.builder(
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
                  context.push(RouteLocation.taskForm);
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

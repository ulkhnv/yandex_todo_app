import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/models.dart';
import '../../providers/providers.dart';
import '../pages/pages.dart';
import '/src/core/utils/utils.dart';

class TaskItem extends ConsumerWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(taskProvider.notifier);

    return Dismissible(
      key: UniqueKey(),
      direction:
          task.done ? DismissDirection.endToStart : DismissDirection.horizontal,
      background: _buildBackgroundContainer(context, true),
      secondaryBackground: _buildBackgroundContainer(context, false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          notifier.markTaskAsDone(task);
        } else if (direction == DismissDirection.endToStart) {
          notifier.deleteTask(task);
        }
      },
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 10),
        horizontalTitleGap: 0,
        leading: _buildLeading(context, notifier),
        title: _buildTitle(context),
        trailing: _buildTrailing(context),
      ),
    );
  }

  Widget _buildBackgroundContainer(BuildContext context, bool isFirst) {
    return Container(
      color: isFirst ? context.customColors.green : context.customColors.red,
      child: Row(
        mainAxisAlignment:
            isFirst ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isFirst) const SizedBox(width: 15),
          Icon(
            isFirst ? Icons.check : Icons.delete,
            color: context.customColors.white,
          ),
          if (!isFirst) const SizedBox(width: 15),
        ],
      ),
    );
  }

  Widget _buildLeading(BuildContext context, TaskNotifier notifier) {
    return Checkbox(
      value: task.done,
      activeColor: context.customColors.green,
      onChanged: (value) {
        notifier.markTaskAsDone(task);
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (task.importance == TaskImportance.important)
          Icon(
            Icons.priority_high_rounded,
            color: context.customColors.red,
          ),
        if (task.importance == TaskImportance.low)
          Icon(
            Icons.arrow_downward_rounded,
            color: context.customColors.grey,
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.text,
                style: task.done
                    ? context.textTheme.bodyMedium!.copyWith(
                        color: context.colorScheme.tertiary,
                        decoration: TextDecoration.lineThrough,
                      )
                    : context.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              task.deadline != null
                  ? Text(
                      DateFormat('dd MMMM yyyy', 'ru').format(task.deadline!),
                      style: context.textTheme.bodySmall,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskFormPage(task: task)),
        );
      },
      child: Icon(
        Icons.info_outline_rounded,
        color: context.colorScheme.tertiary,
      ),
    );
  }
}

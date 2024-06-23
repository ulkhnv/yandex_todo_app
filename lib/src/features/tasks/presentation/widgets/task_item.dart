import 'package:flutter/material.dart';
import 'package:yandex_todo_app/src/core/utils/utils.dart';

import '../../domain/entities/entities.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        decoration: BoxDecoration(
          color: context.customColors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Icon(
              Icons.check,
              color: context.customColors.white,
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: context.customColors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete,
              color: context.customColors.white,
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 10),
        horizontalTitleGap: 0,
        leading: Checkbox(
          value: false,
          onChanged: (value) {},
        ),
        title: Text(
          task.text,
          style: context.textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.info_outline),
      ),
    );
  }
}

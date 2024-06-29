import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../pages/pages.dart';
import '/src/core/utils/utils.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: _buildBackgroundContainer(context, true),
      secondaryBackground: _buildBackgroundContainer(context, false),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 10),
        horizontalTitleGap: 0,
        leading: _buildLeading(context),
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

  Widget _buildLeading(BuildContext context) {
    return Checkbox(
      value: task.done,
      activeColor: context.customColors.green,
      fillColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return context.customColors.green;
        }
        return task.importance == TaskImportance.important
            ? context.customColors.red.withOpacity(0.16)
            : Colors.transparent;
      }),
      side: BorderSide(
        width: 2,
        color: task.importance == TaskImportance.important
            ? context.customColors.red
            : context.customColors.separator,
      ),
      onChanged: (value) {
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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

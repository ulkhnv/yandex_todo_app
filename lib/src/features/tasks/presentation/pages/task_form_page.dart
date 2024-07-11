import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/models.dart';
import '../../providers/providers.dart';
import '/src/core/utils/utils.dart';

class TaskFormPage extends ConsumerStatefulWidget {
  final Task? task;

  const TaskFormPage({super.key, this.task});

  @override
  ConsumerState<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends ConsumerState<TaskFormPage> {
  late TaskNotifier notifier;
  final textEditingController = TextEditingController();
  TaskImportance _selectedImportance = TaskImportance.basic;
  bool _isDeadlineEnabled = false;
  DateTime? _selectedDeadline;

  @override
  void initState() {
    super.initState();
    notifier = ref.read(taskProvider.notifier);
    final task = widget.task;
    if (task != null) {
      textEditingController.text = task.text;
      _selectedImportance = task.importance;
      if (task.deadline != null) {
        _isDeadlineEnabled = true;
        _selectedDeadline = task.deadline;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(context),
            const SizedBox(height: 16),
            _buildImportanceSelector(context),
            const Divider(thickness: 0.5, indent: 16, endIndent: 16),
            _buildDeadlineSelector(context),
            const Divider(thickness: 0.5),
            _buildDeleteButton(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 4,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.close, color: context.colorScheme.primary),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: TextButton(
            onPressed: _saveOrUpdateTask,
            child: Text(
              context.localizations.save,
              style: context.textTheme.labelMedium!
                  .copyWith(color: context.customColors.blue),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          minLines: 4,
          maxLines: 40,
          style: context.textTheme.bodyMedium,
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: context.localizations.formHintText,
            hintStyle: context.textTheme.bodyMedium!
                .copyWith(color: context.colorScheme.tertiary),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: context.customColors.grey, width: 0.1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: context.customColors.grey, width: 0.1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImportanceSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PopupMenuButton<TaskImportance>(
        constraints: const BoxConstraints(minWidth: 164),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            context.localizations.importanceTitle,
            style: context.textTheme.bodyMedium,
          ),
          subtitle: Text(
            context.localizations.importance(_selectedImportance.name),
            style: context.textTheme.bodySmall,
          ),
        ),
        onSelected: (value) {
          setState(() {
            _selectedImportance = value;
          });
        },
        itemBuilder: (BuildContext context) => TaskImportance.values
            .map((importance) => PopupMenuItem<TaskImportance>(
                  value: importance,
                  child: Text(
                    context.localizations.importance(importance.name),
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: importance == TaskImportance.important
                          ? context.customColors.red
                          : null,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDeadlineSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          context.localizations.deadlineTitle,
          style: context.textTheme.bodyMedium,
        ),
        subtitle: _buildFormattedDate(context),
        activeTrackColor: context.customColors.blue.withOpacity(0.3),
        activeColor: context.customColors.blue,
        inactiveTrackColor: context.customColors.overlay,
        inactiveThumbColor: context.customColors.white,
        value: _isDeadlineEnabled,
        onChanged: (newValue) async {
          if (newValue) {
            final selectedDate = await showDatePicker(
              context: context,
              locale: const Locale("ru"),
              confirmText: context.localizations.done,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (selectedDate != null) {
              setState(() {
                _isDeadlineEnabled = true;
                _selectedDeadline = selectedDate;
              });
            }
          } else {
            setState(() {
              _isDeadlineEnabled = false;
              _selectedDeadline = null;
            });
          }
        },
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Row(
      children: [
        IconButton(
          splashRadius: 20,
          onPressed: widget.task == null ? null : deleteTask,
          icon: Icon(
            Icons.delete,
            color: widget.task == null
                ? context.customColors.disable
                : context.customColors.red,
          ),
        ),
        Text(
          context.localizations.delete,
          style: context.textTheme.bodyMedium!.copyWith(
            color: widget.task == null
                ? context.customColors.disable
                : context.customColors.red,
          ),
        ),
      ],
    );
  }

  Widget? _buildFormattedDate(BuildContext context) {
    if (_selectedDeadline == null) return null;
    return Text(
      DateFormat('dd MMMM yyyy', 'ru').format(_selectedDeadline!),
      style: context.textTheme.bodySmall!
          .copyWith(color: context.customColors.blue),
    );
  }

  void deleteTask() {
    notifier.deleteTask(widget.task!);
    Navigator.pop(context);
  }

  void _saveOrUpdateTask() {
    final text = textEditingController.text.trim();
    if (text.isEmpty) return;

    final newTask = Task(
      id: widget.task?.id ?? const Uuid().v4(),
      text: text,
      importance: _selectedImportance,
      deadline: _selectedDeadline,
      done: widget.task?.done ?? false,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: 'user',
    );

    widget.task == null
        ? notifier.saveTask(newTask)
        : notifier.updateTask(newTask);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

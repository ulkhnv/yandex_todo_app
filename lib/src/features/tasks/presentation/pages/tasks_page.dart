import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/task_provider.dart';
import '../widgets/widgets.dart';
import '/src/core/utils/utils.dart';
import 'pages.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskProvider);
    final notifier = ref.watch(taskProvider.notifier);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: HeaderDelegate(
                isVisible: state.isCompletedVisible,
                completedTasksCount: notifier.getCompletedTaskCount(),
                onToggleVisibility: () {
                  notifier.toggleCompletedVisibility();
                }),
          ),
          SliverToBoxAdapter(
            child: TaskList(
              tasks: state.tasks,
              isVisible: state.isCompletedVisible,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskFormPage()),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_todo_app/src/core/routes/routes.dart';

import '../../providers/task_provider.dart';
import '../widgets/widgets.dart';
import '/src/core/utils/utils.dart';

class TaskPage extends ConsumerWidget {
  const TaskPage({super.key});

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
          state.isLoading
              ? const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverToBoxAdapter(
                  child: TaskList(
                    tasks: state.tasks,
                    isVisible: state.isCompletedVisible,
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RouteLocation.taskForm);
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

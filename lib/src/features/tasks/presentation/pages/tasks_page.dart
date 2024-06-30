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
    final tasksAsyncValue = ref.watch(tasksProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: HeaderDelegate(),
          ),
          SliverToBoxAdapter(
            child: tasksAsyncValue.when(
                data: (tasks) => TaskList(
                      tasks: tasks,
                    ),
                loading: () =>  const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  return Center(
                      child: Text(
                    'Error: $stack',
                  ));
                }),
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

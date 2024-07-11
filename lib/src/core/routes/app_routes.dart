import 'package:go_router/go_router.dart';
import 'package:yandex_todo_app/src/features/tasks/presentation/pages/pages.dart';

import 'routes.dart';

final appRoutes = [
  GoRoute(
    path: RouteLocation.home,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const TaskPage(),
  ),
  GoRoute(
    path: RouteLocation.taskForm,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const TaskFormPage(),
  ),
];

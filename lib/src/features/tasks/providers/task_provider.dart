import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/datasources.dart';
import '../data/repositories/repositories.dart';
import 'providers.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return TaskRemoteDataSource(dio);
});

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return TaskLocalDataSource(sharedPreferences);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final remoteDataSource = ref.watch(taskRemoteDataSourceProvider);
  final localDataSource = ref.watch(taskLocalDataSourceProvider);
  final connectivity = ref.watch(connectivityProvider);
  return TaskRepository(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    connectivity: connectivity,
  );
});

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});

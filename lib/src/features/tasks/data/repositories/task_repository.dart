import 'package:connectivity_plus/connectivity_plus.dart';

import '../datasources/task_local_data_source.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/models.dart';

class TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;
  final TaskLocalDataSource _localDataSource;
  final Connectivity _connectivity;

  TaskRepository({
    required TaskRemoteDataSource remoteDataSource,
    required TaskLocalDataSource localDataSource,
    required Connectivity connectivity,
  })  : _connectivity = connectivity,
        _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  Future<List<Task>> getTasks() async {
    final connectionResult = await _connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.none) {
      return await _localDataSource.getTasks();
    } else {
      try {
        final taskResponse = await _remoteDataSource.getTasks();
        if (!_localDataSource.isSynchronized()) {
          final tasks = await _localDataSource.getTasks();
          await _remoteDataSource.patch(tasks, taskResponse.revision);
          await _localDataSource.setSynchronized(true);
          return tasks;
        }
        await _localDataSource.saveTasks(taskResponse.tasks);
        await _localDataSource.saveRevision(taskResponse.revision);
        return taskResponse.tasks;
      } catch (e) {
        return _localDataSource.getTasks();
      }
    }
  }

  Future<void> saveTask(Task task) async {
    int revision = _localDataSource.getRevision();
    final connectionResult = await _connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.none) {
      await _localDataSource.saveTask(task);
      await _localDataSource.setSynchronized(false);
    } else {
      try {
        await _remoteDataSource.saveTask(task, revision);
        await _localDataSource.saveRevision(++revision);
      } catch (e) {
        await _localDataSource.saveTask(task);
        await _localDataSource.setSynchronized(false);
      }
    }
  }

  Future<void> updateTask(Task task) async {
    int revision = _localDataSource.getRevision();
    final connectionResult = await _connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.none) {
      await _localDataSource.updateTask(task);
      await _localDataSource.setSynchronized(false);
    } else {
      try {
        await _remoteDataSource.updateTask(task, revision);
        await _localDataSource.saveRevision(++revision);
      } catch (e) {
        await _localDataSource.updateTask(task);
        await _localDataSource.setSynchronized(false);
      }
    }
  }

  Future<void> deleteTask(String id) async {
    int revision = _localDataSource.getRevision();
    final connectionResult = await _connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.none) {
      await _localDataSource.deleteTask(id);
      await _localDataSource.setSynchronized(false);
    } else {
      try {
        await _remoteDataSource.deleteTask(id, revision);
        await _localDataSource.saveRevision(++revision);
      } catch (e) {
        await _localDataSource.deleteTask(id);
        await _localDataSource.setSynchronized(false);
      }
    }
  }
}

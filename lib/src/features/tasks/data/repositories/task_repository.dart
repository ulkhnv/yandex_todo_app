import 'package:connectivity_plus/connectivity_plus.dart';

import '../datasources/task_local_data_source.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/models.dart';

class TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final Connectivity connectivity;

  TaskRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  Future<List<Task>> getTasks() async {
    final connectionResult = await connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.none) {
      return localDataSource.getTasks();
    } else {
      try {
        final taskResponse = await remoteDataSource.getTasks();
        localDataSource.saveTasks(taskResponse.tasks);
        localDataSource.saveRevision(taskResponse.revision);
        return taskResponse.tasks;
      } catch (e) {
        return localDataSource.getTasks();
      }
    }
  }

  Future<void> saveTask(Task task) async {
    int revision = localDataSource.getRevision();
    final connectionResult = await connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.none) {
      localDataSource.saveTask(task);
    } else {
      try {
        await remoteDataSource.saveTask(task, revision);
        localDataSource.saveRevision(++revision);
      } catch (e) {
        localDataSource.saveTask(task);
      }
    }
  }

  Future<void> updateTask(Task task) async {
    int revision = localDataSource.getRevision();
    final connectionResult = await connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.none) {
      localDataSource.updateTask(task);
    } else {
      try {
        await remoteDataSource.updateTask(task, revision);
        localDataSource.saveRevision(++revision);
      } catch (e) {
        localDataSource.updateTask(task);
      }
    }
  }

  Future<void> deleteTask(String id) async {
    int revision = localDataSource.getRevision();
    final connectionResult = await connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.none) {
      localDataSource.deleteTask(id);
    } else {
      try {
        await remoteDataSource.deleteTask(id, revision);
        await localDataSource.saveRevision(++revision);
      } catch (e) {
        localDataSource.deleteTask(id);
      }
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_manager_pro/modules/tasks/models/task_model.dart';
import 'package:life_manager_pro/data/local/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final TaskRepository _repository;
  
  TaskNotifier(this._repository) : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = await _repository.getAllTasks();
  }

  Future<void> addTask(Task task) async {
    await _repository.addTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _repository.deleteTask(id);
    await loadTasks();
  }

  Future<void> toggleTaskStatus(Task task) async {
    if (task.status == TaskStatus.done) {
      task.status = TaskStatus.todo;
      task.completedAt = null;
    } else {
      task.status = TaskStatus.done;
      task.completedAt = DateTime.now();
    }
    await updateTask(task);
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});
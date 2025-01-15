import 'package:flutter/cupertino.dart';
import 'package:todo_provider/model/task_model.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  //getter to get list of tasks
  List<Task> get tasks => _tasks;

  void addTask(String title, String description) {
    _tasks.add(Task(title: title, description: description));
    notifyListeners();
  }

  void editTask(String title, String description, int index) {
    _tasks[index] = Task(title: title, description: description);
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void toggleTaskStatus(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/provider/task_provider.dart';

class TodoHome extends StatelessWidget {
  TodoHome({super.key});

  final TextEditingController taskTitle = TextEditingController();
  final TextEditingController taskDescription = TextEditingController();
  final TextEditingController editTitle = TextEditingController();
  final TextEditingController editDescription = TextEditingController();
  final ValueNotifier<bool> showWarning = ValueNotifier(false);

  void addNewTask(
    BuildContext context,
    TaskProvider taskProvider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            30,
            20,
            MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Add New Task',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: taskTitle,
                autofocus: true,
                focusNode: FocusNode(),
                decoration: InputDecoration(hintText: 'Task Name'),
              ),
              SizedBox(height: 20),

              TextField(
                controller: taskDescription,
                focusNode: FocusNode(),
                decoration: InputDecoration(hintText: 'Task Description'),
                minLines: 3,
                maxLines: 5,
              ),
              SizedBox(height: 20),

              // Display warning if task title is empty
              ValueListenableBuilder<bool>(
                valueListenable: showWarning,
                builder: (context, value, child) {
                  if (!value) {
                    return Container();
                  }
                  return Text(
                    'Text Fields can\'t be empty',
                    style: TextStyle(color: Colors.red),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.maxFinite,
                  child: TextButton(
                    onPressed: () {
                      if (taskTitle.text.trim() == '' ||
                          taskDescription.text.trim() == '') {
                        showWarning.value = true;

                        Future.delayed(Duration(seconds: 3), () {
                          showWarning.value = false;
                        });

                        return;
                      }
                      taskProvider.addTask(
                          taskTitle.text, taskDescription.text);
                      taskTitle.clear();
                      taskDescription.clear();
                      showWarning.value = false;
                      Navigator.pop(context);
                    },
                    child: Text('Add Task'),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void editTask(
    BuildContext context,
    TaskProvider taskProvider,
    index,
  ) {
    editTitle.text = taskProvider.tasks[index].title;
    editDescription.text = taskProvider.tasks[index].description;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            30,
            20,
            MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Edit ${taskProvider.tasks[index].title}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: editTitle,
                focusNode: FocusNode(),
                decoration: InputDecoration(hintText: 'Task Name'),
              ),
              SizedBox(height: 20),

              TextField(
                controller: editDescription,
                focusNode: FocusNode(),
                decoration: InputDecoration(hintText: 'Task Description'),
                minLines: 3,
                maxLines: 5,
              ),
              SizedBox(height: 20),

              // Display warning if task title is empty
              ValueListenableBuilder<bool>(
                valueListenable: showWarning,
                builder: (context, value, child) {
                  if (!value) {
                    return Container();
                  }
                  return Text(
                    'Text Fields can\'t be empty',
                    style: TextStyle(color: Colors.red),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.maxFinite,
                  child: TextButton(
                    onPressed: () {
                      if (editTitle.text.trim() == '' ||
                          editDescription.text.trim() == '') {
                        showWarning.value = true;

                        Future.delayed(Duration(seconds: 3), () {
                          showWarning.value = false;
                        });
                        return;
                      }
                      taskProvider.editTask(
                          editTitle.text, editDescription.text, index);
                      editTitle.clear();
                      editDescription.clear();
                      showWarning.value = false;
                      Navigator.pop(context);
                    },
                    child: Text('Update Task'),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void confirmDeleteTask(
    BuildContext context,
    TaskProvider taskProvider,
    int index,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20, 30, 20, MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Confirm Delete ${taskProvider.tasks[index].title} ?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      taskProvider.deleteTask(index);
                      Navigator.pop(context);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo with Provider'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewTask(context, taskProvider);
        },
        child: Icon(CupertinoIcons.plus),
      ),
      body: taskProvider.tasks.isEmpty
          ? Center(
              child: Text('No Pending Tasks!'),
            )
          : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) {
                              taskProvider.toggleTaskStatus(index);
                            },
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                editTask(context, taskProvider, index);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(task.title,
                                      style: task.isCompleted
                                          ? TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey)
                                          : null),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(task.description,
                                      style: task.isCompleted
                                          ? TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey)
                                          : null),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          IconButton(
                            onPressed: () {
                              confirmDeleteTask(context, taskProvider, index);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1),
                      child: Divider(),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

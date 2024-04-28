import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atividade_flutter/model/task.dart';
import 'package:atividade_flutter/provider/task_provider.dart';
import 'package:atividade_flutter/util/date_formatted.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  void addTask() {
    if (formKey.currentState?.validate() ?? false) {
      if (selectedDate == null) {
        showError('Must have a due date');
        return;
      }

      if (selectedStatus == null) {
        showError('Must have a status');
        return;
      }

      final newTask = Task(
        id: Random().nextInt(10000).toString(),
        title: titleController.text,
        status: selectedStatus!,
        dueTo: selectedDate!,
      );

      Provider.of<TaskProvider>(context, listen: false).addTask(newTask);

      Navigator.of(context).pop();
    }
  }

  late final TextEditingController titleController;
  DateTime? selectedDate;
  TaskStatus? selectedStatus;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  child: TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'tarefa',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Must have a title';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2030),
                        ).then((value) => setState(() {
                              selectedDate = value;
                            }));
                      },
                      child: const Text('data'),
                    ),
                    if (selectedDate != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          DateFormatter.formatDate(selectedDate!),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownMenu<TaskStatus>(
                  label: const Text("Status"),
                  width: 200,
                  onSelected: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                  dropdownMenuEntries: TaskStatus.values
                      .map(
                        (e) => DropdownMenuEntry<TaskStatus>(
                          value: e,
                          label: e.name,
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(e.color),
                            overlayColor: MaterialStatePropertyAll(e.color),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: addTask,
                  child: const Text('adicionar tarefa'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

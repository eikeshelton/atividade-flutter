// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atividade_flutter/provider/task_provider.dart';
import 'package:atividade_flutter/routes.dart';
import 'package:atividade_flutter/view/task_list/task_card.dart';

class TaskListPage extends StatelessWidget {
  TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (BuildContext context, TaskProvider provider, Widget? child) =>
          Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
        ),
        body: provider.tasks.isEmpty
            ? const Center(
                child: Text('No tasks here... Create a task'),
              )
            : ListView.builder(
                itemCount: provider.tasks.length,
                itemBuilder: (context, index) => TaskCard(
                    task: provider.tasks.elementAt(index), onRemove: (task) {}),
              ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.add);
          },
        ),
      ),
    );
  }
}

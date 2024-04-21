import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atividade_flutter/model/task.dart';

import 'package:atividade_flutter/provider/task_provider.dart';
import 'package:atividade_flutter/util/date_formatted.dart';
import 'package:atividade_flutter/view/task_list/delete_task_modal.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({required this.task, super.key, required this.onRemove});

  final Task task;
  final void Function(Task task) onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: task.status.color,
      key: Key('${task.id}tile'),
      child: Column(
        children: [
          Text(
            task.title,
            style: theme.textTheme.headlineLarge,
          ),
          Text(DateFormatter.formatDate(task.dueTo)),
          Text(task.status.name),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const DeleteTaskModal(),
                ).then((mustDelete) {
                  if (mustDelete) {
                    Provider.of<TaskProvider>(context, listen: false)
                        .delete(task);
                  }
                });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
    );
  }
}

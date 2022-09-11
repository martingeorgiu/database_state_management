import 'package:flutter/material.dart';
import 'package:moor_state_management/services/database.dart';

void showAddTodoDialog(BuildContext context, AppDatabase database) {
  showDialog(
    context: context,
    builder: (context) {
      final todoController = TextEditingController();
      return AlertDialog(
        title: const Text('Add todo'),
        content: TextFormField(
          controller: todoController,
          decoration: const InputDecoration(hintText: 'Todo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (todoController.text.isNotEmpty) {
                Navigator.pop(context);
                await database.todoDao.createTodo(todoController.text);
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:moor_state_management/services/database.dart';
import 'package:moor_state_management/services/registry.dart';

class HomePage extends StatelessWidget {
  final database = registry.get<AppDatabase>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('todo app'),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: database.todoDao.watchAll(),
        builder: (ctx, snp) {
          if (!snp.hasData) {
            return const SizedBox.shrink();
          } else if (snp.data!.isEmpty) {
            return const Center(child: Text('no todos 🎉'));
          } else {
            final data = snp.data!;
            data.sort((a, b) {
              if (a.done) {
                return 1;
              }
              return -1;
            });
            return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(data[i].content),
                leading: Checkbox(
                  value: data[i].done,
                  onChanged: (value) async {
                    await database.todoDao.updateDoneStatus(id: data[i].id, done: value ?? false);
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await database.todoDao.deleteTodo(data[i].id);
                  },
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogWithFields(context);
        },
        tooltip: 'Add todo',
        child: const Icon(Icons.add),
      ),
    );
  }

  void showDialogWithFields(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) {
        final todoController = TextEditingController();
        return AlertDialog(
          title: const Text('Add todo'),
          content: TextFormField(
            controller: todoController,
            decoration: const InputDecoration(hintText: 'Todo'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (todoController.text.isNotEmpty) {
                  Navigator.pop(ctx);
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
}

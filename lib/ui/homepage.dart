import 'package:flutter/material.dart';
import 'package:moor_state_management/services/database.dart';
import 'package:moor_state_management/services/registry.dart';
import 'package:moor_state_management/ui/add_todo_dialog.dart';

class HomePage extends StatelessWidget {
  final database = registry.get<AppDatabase>();

  int todoSort(Todo a, Todo b) {
    if (a.done) {
      return 1;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('todo app'),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: database.todoDao.watchAll(),
        builder: (ctx, snp) {
          final data = snp.data;
          if (data == null) {
            return const SizedBox.shrink();
          } else if (data.isEmpty) {
            return const Center(child: Text('no todos 🎉'));
          } else {
            data.sort(todoSort);
            return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (ctx, i) => ListTile(
                key: ValueKey(data[i].id),
                title: Text(data[i].content),
                leading: Checkbox(
                  value: data[i].done,
                  onChanged: (value) async {
                    final v = value;
                    if (v == null) return;
                    await database.todoDao.updateDoneStatus(id: data[i].id, done: v);
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => database.todoDao.deleteTodo(data[i].id),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTodoDialog(context, database),
        tooltip: 'Add todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}

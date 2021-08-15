import 'package:flutter/material.dart';
import 'package:moor_state_management/services/database.dart';
import 'package:moor_state_management/services/registry.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final database = registry.get<AppDatabase>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('todo app'),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: database.todoDao.watchAll(),
        builder: (ctx, snp) {
          if (!snp.hasData) {
            return SizedBox.shrink();
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
                trailing: Checkbox(
                  value: data[i].done,
                  onChanged: (value) async {
                    await database.todoDao
                        .updateDoneStatus(data[i].id, value ?? false);
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
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showDialogWithFields(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) {
        final todoController = TextEditingController();
        return AlertDialog(
          title: Text('Add todo'),
          content: TextFormField(
            controller: todoController,
            decoration: InputDecoration(hintText: 'Todo'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await database.todoDao.createTodo(todoController.text);
                Navigator.pop(ctx);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

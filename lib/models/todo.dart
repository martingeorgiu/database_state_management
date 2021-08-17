import 'package:moor/moor.dart';
import 'package:moor_state_management/services/database.dart';

part 'todo.g.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get content => text()();
  BoolColumn get done => boolean()();
}

@UseDao(tables: [Todos])
class TodoDao extends DatabaseAccessor<AppDatabase> with _$TodoDaoMixin {
  TodoDao(AppDatabase db) : super(db);

  Stream<List<Todo>> watchAll() {
    return select(todos).watch();
  }

  Future<void> updateDoneStatus({required int id, required bool done}) async {
    await (update(todos)..where((tbl) => tbl.id.equals(id)))
        .write(TodosCompanion(done: Value(done)));
  }

  Future<void> createTodo(String content) async {
    await into(todos).insert(TodosCompanion(content: Value(content), done: const Value(false)));
  }
}

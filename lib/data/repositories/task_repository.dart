import 'package:mysql_manager/mysql_manager.dart';
import 'package:task_manager/data/models/task_model.dart';

class TaskRepository {
  Future<Task> create(Task task) async {
    final connection = MySQLManager.instance.conn!;
    try {
      final prepareStatement = (await connection.prepare(
        'INSERT INTO tasks(id, name,category,project_id) VALUES(?,?,?,?)',
      
      ));
      final result = await prepareStatement.execute([task.id, task.name, task.category,task.projectId]);
      await prepareStatement.deallocate();
      
      print(result.rows.toList());
      return task;
    } catch (err) {
      print(err);
      rethrow;
    }
    ;
  }

  Future<List<Task>> getAll(String projectId) async {
    final connection = MySQLManager.instance.conn!;
    final rows = (await connection.execute(
            'SELECT * FROM tasks where project_id= :projectId',
            {"projectId": projectId}))
        .rows
        .toList();
    return rows.map((e) => Task.fromMap(e.typedAssoc())).toList();
  }

  Future<void> update(Task project) async {}
}

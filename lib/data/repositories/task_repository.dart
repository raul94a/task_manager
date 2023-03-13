import 'package:mysql_manager/mysql_manager.dart';
import 'package:task_manager/data/models/task_model.dart';

class TaskRepository {
  Future<Task> create(Task task) async {
    final connection = MySQLManager.instance.conn!;
    final row = (await connection.execute(
        'INSERT INTO projects(name,category,project_id) VALUES(${task.name}, ${task.category}, ${task.projectId} )'));
    print(row.rows.toList());

    return task;
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

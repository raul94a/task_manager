import 'package:mysql_manager/mysql_manager.dart';
import 'package:task_manager/data/models/project_model.dart';

class ProjectRepository {
  Future<Project> create(Project project) async {
    final connection = MySQLManager.instance.conn!;
    final row = (await connection
        .execute('INSERT INTO projects(name) VALUES(${project.name})'));
    print(row.rows.toList());

    return project;
  }

  Future<List<Project>> getAll() async {
    final connection = MySQLManager.instance.conn!;
    final rows =
        (await connection.execute('SELECT * FROM projects')).rows.toList();
    return rows.map((e) => Project.fromMap(e.typedAssoc())).toList();
  }

  Future<void> update(Project project) async {}
}

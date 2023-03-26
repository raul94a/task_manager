import 'package:mysql_manager/mysql_manager.dart';
import 'package:task_manager/data/models/project_model.dart';

class ProjectRepository {
  Future<Project> create(Project project) async {
    print('On create project...');
    final connection = MySQLManager.instance.conn!;
    try {
      final preparedStatement = (await connection
          .prepare('INSERT INTO projects(id,name) VALUES(?,?)'));
      await preparedStatement.execute([project.id, project.name]);
      await preparedStatement.deallocate();

      return project;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<Project>> getAll() async {
    try {
      final connection = MySQLManager.instance.conn!;
      final rows = (await connection
              .execute('SELECT * FROM projects where active is TRUE'))
          .rows
          .toList();
      return rows.map((e) => Project.fromMap(e.typedAssoc())).toList();
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> update(Project project) async {
    print('On update project...');
    final connection = MySQLManager.instance.conn!;
    try {
      final preparedStatement = (await connection
          .prepare('update projects set name = ? where id = ?'));
      await preparedStatement.execute([project.name, project.id]);
      await preparedStatement.deallocate();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    print('On delete project...');
    final connection = MySQLManager.instance.conn!;
    try {
      final preparedStatement = (await connection
          .prepare('update projects set active = FALSE where id = ?'));
      await preparedStatement.execute([id]);
      await preparedStatement.deallocate();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }
}

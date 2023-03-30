import 'package:mysql_manager_flutter/mysql_manager_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/extensions/context_extension.dart';
import 'package:task_manager/data/db/queries.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/logic/project_bloc.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/provider/theme_provider.dart';
import 'package:task_manager/views/app.dart';
import 'package:task_manager/views/features/database_rescue/database_rescue_handler.dart';
import 'package:task_manager/views/styles/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Init db connection
  final error = await initializeDb(null, true);
  runApp(ProviderScope(child: MainApp(error: error)));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key, required this.error});
  final bool error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Error: $error');

    final darkMode = ref.watch(themeState.select((value) => value.darkMode));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: !darkMode ? lightTheme : darkTheme,
      home: Scaffold(
        body: Center(
          child: Visibility(
              replacement: const SetDatabaseConfigurationPage(),
              visible: !error,
              child: const InitApp()),
        ),
      ),
    );
  }
}

class InitApp extends ConsumerStatefulWidget {
  const InitApp({super.key});

  @override
  ConsumerState<InitApp> createState() => _InitAppState();
}

class _InitAppState extends ConsumerState<InitApp> {
  bool error = false;
  void _fetchProjects() {
    final projectBloc = ProjectBloc(ref: ref, context: context);
    try {
      projectBloc.getProjects().catchError((err, stack) async {
        setState(() {
          error = true;
        });
        return <Project>[];
      }).then((projects) {
        print('Projects: $projects');
        if (projects.isNotEmpty) {
          print(projects);
          final project = projects.first;
          final taskBloc = TasksProjectBloc(ref: ref);

          taskBloc.getByProject(project.id).then((_) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const App()));
          });
        } else {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => const App()));
        }
      });
    } catch (ex) {
      print('HA OCURRIDO UNA EXP');
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      _fetchProjects();
    } catch (ex) {
      print('ha ocurrido una expceiton $ex');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error) {
      return Center(
        child: Column(
          children: [
            const Text('Ha ocurrido un error'),
            IconButton(
                onPressed: () async {
                  main();
                },
                icon: const Icon(
                  Icons.error,
                  color: Colors.pink,
                  size: 50,
                )),
          ],
        ),
      );
    }
    return const CircularProgressIndicator();
  }
}

Future<bool> initializeDb(Map<String, String>? config,
    [bool withEnvFile = true]) async {
  try {
    await MySQLManager.instance.saveDatabaseConfigurationOnce(config ?? {});
    await MySQLManager.instance
        .init(useEnvFile: withEnvFile, config: config ?? {}, timeoutMs: 3000);
    final conn = MySQLManager.instance.conn!;
    //The app creates the required database and tables
    //This is only useful if there's one user in the app! (standalone)
    for (final query in queries) {
      try {
        await conn.execute(query);
      } catch (_) {}
    }

    return false;
  } catch (exception) {
    print('Error estableciendo la conexión con la base de datos $exception');
    return true;
  }
}

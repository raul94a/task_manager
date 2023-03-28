import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_manager/mysql_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/data/db/queries.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/logic/project_bloc.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/provider/project_provider.dart';
import 'package:task_manager/provider/theme_provider.dart';
import 'package:task_manager/views/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Init db connection
  final config = <String, String>{};
  await getConfig(config);
  print(config);
  final error = await initializeDb(config);
  runApp(ProviderScope(child: MainApp(error: error)));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key, required this.error});
  final bool error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Error: $error');
    final controller = TextEditingController(
      text:
          'db=task_manager\nhost=localhost\nuser=root\npassword=root\nport=3306',
    );
    final darkMode = ref.watch(themeState.select((value) => value.darkMode));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: !darkMode
          ? ThemeData.light().copyWith(
              textTheme: const TextTheme(
                displayLarge: TextStyle(color: Colors.black),
                displayMedium: TextStyle(color: Colors.black),
                displaySmall: TextStyle(color: Colors.black),

                labelMedium: TextStyle(color: Colors.white, fontSize: 14.2),
                labelLarge: TextStyle(color: Colors.black),

                labelSmall: TextStyle(color: Colors.black),
                bodyLarge: TextStyle(color: Colors.black),
                //TEXT
                bodyMedium: TextStyle(
                    color: Colors.black, fontSize: 14.2),
                bodySmall: TextStyle(color: Colors.black),
                headlineSmall: TextStyle(color: Colors.white, fontSize: 14.2),
                headlineMedium: TextStyle(color: Colors.white, fontSize: 14.2),
                headlineLarge: TextStyle(color: Colors.white, fontSize: 14.2),
                titleLarge: TextStyle(color: Colors.black, fontSize: 14.2),
                titleMedium: TextStyle(color: Colors.black, fontSize: 14.2),
                titleSmall: TextStyle(color: Colors.white, fontSize: 14.2),
              ),
            )
          : ThemeData(
              textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: Color.fromARGB(255, 238, 225, 225),
                  selectionColor: Colors.pink),
              // dialogBackgroundColor:Color.fromARGB(255, 51, 50, 50),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => const Color.fromARGB(255, 63, 63, 63)))),
              dialogTheme: const DialogTheme(
                backgroundColor: Color.fromARGB(255, 44, 44, 44),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                errorMaxLines: 2,
                fillColor: Color.fromARGB(246, 56, 56, 56),
                filled: true,
                labelStyle: TextStyle(color: Colors.black, fontSize: 14.2),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 240, 240, 240), width: 0.75),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.75),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 240, 240, 240), width: 0.75),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 240, 240, 240), width: 0.75),
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              textTheme: const TextTheme(
                displayLarge: TextStyle(color: Colors.white),
                displayMedium: TextStyle(color: Colors.white),
                displaySmall: TextStyle(color: Colors.white),

                labelMedium: TextStyle(color: Colors.black, fontSize: 14.2),
                labelLarge: TextStyle(color: Colors.white),

                labelSmall: TextStyle(color: Colors.white),
                bodyLarge: TextStyle(color: Colors.white),
                //TEXT
                bodyMedium: TextStyle(
                    color: Color.fromARGB(255, 240, 239, 239), fontSize: 14.2),
                bodySmall: TextStyle(color: Colors.white),
                headlineSmall: TextStyle(color: Colors.black, fontSize: 14.2),
                headlineMedium: TextStyle(color: Colors.black, fontSize: 14.2),
                headlineLarge: TextStyle(color: Colors.black, fontSize: 14.2),
                titleLarge: TextStyle(color: Colors.white, fontSize: 14.2),
                titleMedium: TextStyle(color: Colors.white, fontSize: 14.2),
                titleSmall: TextStyle(color: Colors.black, fontSize: 14.2),
              ),
            ),
      home: Scaffold(
        body: Center(
          child: Visibility(
              replacement: Center(
                child: Column(
                  children: [
                    const Text('La conexión con la base de datos ha fallado'),
                    TextFormField(
                      controller: controller,
                      maxLines: 6,
                      decoration: InputDecoration(hintText: ''),
                    ),
                    IconButton(
                        onPressed: () async {
                          final directory =
                              await getApplicationSupportDirectory();
                          String envFileDocument =
                              directory.path + path.separator + '.env';
                          File(envFileDocument)
                              .writeAsStringSync(controller.text);
                          main();
                        },
                        icon: const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        )),
                  ],
                ),
              ),
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
                  color: Colors.red,
                  size: 50,
                )),
          ],
        ),
      );
    }
    return const CircularProgressIndicator();
  }
}

class ProjectForm extends ConsumerStatefulWidget {
  const ProjectForm({super.key});

  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(projectsState);
    if (notifier.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
              hintText: 'Introduce el nombre del proyecto'),
        ),
        ElevatedButton(
            onPressed: () {
              ProjectBloc(ref: ref, context: context)
                  .createProject(controller.text);
            },
            child: const Text('Crear proyecto'))
      ],
    );
  }
}

Future<Map<String, String>> getConfig(Map<String, String> config) async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    print('Starting on Desktop!!!!');
    //how?
    final directory = await getApplicationSupportDirectory();
    String envFileDocument = directory.path + path.separator + '.env';
    File env = File(envFileDocument);
    if (await env.exists()) {
      print(envFileDocument);
      List<String> lines = env.readAsLinesSync();
      for (final line in lines) {
        final keyValue = line.split('=');
        config.addAll({keyValue.first: keyValue.last});
      }
    } else {
      print(envFileDocument);
      await File(envFileDocument).writeAsString('''
db=mysql
host=localhost
user=root
password=root
port=3306''');
    }
  }
  return config;
}

Future<bool> initializeDb(Map<String, String> config) async {
  try {
    await MySQLManager.instance.init(false, config);
    final conn = MySQLManager.instance.conn!;
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_manager/mysql_manager.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/logic/project_bloc.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/provider/project_provider.dart';
import 'package:task_manager/views/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Init db connection
  bool error = false;
  try {
    await MySQLManager.instance.init();
  } catch (exception) {
    print('Error estableciendo la conexión con la base de datos');
    error = true;
  }
  runApp(ProviderScope(child: MainApp(error: error)));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key, required this.error});
  final bool error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Error: $error');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dialogTheme: DialogTheme(
          backgroundColor:    Color.fromARGB(255, 22, 21, 21),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          
          labelStyle: TextStyle(color: Colors.black, fontSize: 14.2),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme:  const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.black, fontSize: 14.2),
          labelLarge: TextStyle(color: Colors.white),
          //TEXT
          bodyMedium: TextStyle(
              color: Color.fromARGB(255, 240, 239, 239), fontSize: 14.2),
          labelSmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.black, fontSize: 14.2),
          headlineMedium: TextStyle(color: Colors.black, fontSize: 14.2),
          headlineLarge: TextStyle(color: Colors.black, fontSize: 14.2),
          titleLarge: TextStyle(color: Colors.black, fontSize: 14.2),
          titleMedium: TextStyle(color: Colors.black, fontSize: 14.2),
          titleSmall: TextStyle(color: Colors.black, fontSize: 14.2),
         
        ),
      ),
      home: Scaffold(
        body: Center(
          child: Visibility(
              replacement: Center(
                child: Column(
                  children: [
                    const Text('Ha ocurrido un error'),
                    IconButton(
                        onPressed: () {},
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
        if (projects.isNotEmpty) {
          print(projects);
          final project = projects.first;
          final taskBloc = TasksProjectBloc(ref: ref);

          taskBloc.getByProject(project.id).then((_) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const App()));
          });
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
                onPressed: () {
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

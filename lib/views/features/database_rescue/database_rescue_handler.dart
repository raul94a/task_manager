import 'package:flutter/material.dart';
import 'package:mysql_manager_flutter/mysql_manager_flutter.dart';
import 'package:task_manager/core/extensions/context_extension.dart';
import 'package:task_manager/main.dart';

class SetDatabaseConfigurationPage extends StatefulWidget {
  const SetDatabaseConfigurationPage({
    super.key,
  });

  @override
  State<SetDatabaseConfigurationPage> createState() =>
      _SetDatabaseConfigurationPageState();
}

class _SetDatabaseConfigurationPageState
    extends State<SetDatabaseConfigurationPage> {
  final hostController = TextEditingController(),
      userController = TextEditingController(),
      passwordController = TextEditingController(),
      portController = TextEditingController();
  final hostFocus = FocusNode();
  final userFocus = FocusNode();
  final passFocus = FocusNode();
  final portFocus = FocusNode();
  List<FocusNode> focus = [];
  @override
  void initState() {
    focus = [hostFocus, userFocus, passFocus, portFocus];
    super.initState();
  }

  @override
  void dispose() {
    hostController.dispose();
    userController.dispose();
    passwordController.dispose();
    portController.dispose();
    for (final foco in focus) {
      foco.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.black, fontSize: 18.0);
    return SizedBox(
      width: context.width * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              'La conexión con la base de datos ha fallado',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: Text(
              'Rellena el siguiente formulario para configurar la conexión a MySQL',
              style: textStyle.copyWith(fontSize: 22.2),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          FormOption(
            controller: hostController,
            option: 'Host',
          ),
          FormOption(controller: userController, option: 'Usuario'),
          FormOption(
              controller: passwordController,
              option: 'Contraseña',
              isPassword: true),
          FormOption(controller: portController, option: 'Puerto'),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton.icon(
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.resolveWith(
                        (states) => Size(context.width * 0.5 - 15, 50))),
                label: Text('Aceptar cambios'),
                onPressed: () async {
                  final host = hostController.text;
                  final user = userController.text;
                  final password = passwordController.text;
                  final port = portController.text;
                  await MySQLManager.instance.saveDatabaseConfiguration({
                    'host': host,
                    'user': user,
                    'password': password,
                    'port': port,
                  });
                  main();
                  // await MySQLManager.instance
                  //     .saveDatabaseConfiguration(widget.controller.text);
                  // main();
                },
                icon: const Icon(
                  Icons.error,
                  color: Colors.blue,
                  size: 50,
                )),
          ),
        ],
      ),
    );
  }
}

class FormOption extends StatefulWidget {
  const FormOption(
      {super.key,
      required this.controller,
      required this.option,
      this.isPassword = false});

  final TextEditingController controller;
  final String option;
  final bool isPassword;

  @override
  State<FormOption> createState() => _FormOptionState();
}

class _FormOptionState extends State<FormOption> {
  bool seePassword = false;
  changeShowStatus() => setState(() => seePassword = !seePassword);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seePassword = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            width: context.width * 0.1,
            child: Text(
              widget.option,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextFormField(
              obscureText: seePassword,
              controller: widget.controller,
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.black12,
              maxLines: 1,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: '',
                  suffix: widget.isPassword
                      ? IconButton(
                          onPressed: changeShowStatus,
                          icon: Icon(
                            !seePassword ? Icons.lock : Icons.remove_red_eye,
                            color: Colors.black,
                          ))
                      : null),
            ),
          ),
        ],
      ),
    );
  }
}

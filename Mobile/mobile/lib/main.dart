import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}
//Cor global para a dinamica dos inputs
Color InputsColor = Color(0xff808080);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitaHealth',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightGreen,
      ),
      home: const MyHomePage(title: 'VitaHealth'),
      debugShowCheckedModeBanner: false,
    );
  }
}

//Widget de Input para o email
class EmailForm extends StatefulWidget {
  const EmailForm({Key? key}) : super(key: key);

  @override
  _EmailFormState createState() => _EmailFormState();
}

//Guarda o valor do input do email
class _EmailFormState extends State<EmailForm> {
  //Controlador de texto que recebe o valor do input. Estatico para que haja acesso global
  static final controladorEmailForm = TextEditingController();

  @override
  void dispose() {
    controladorEmailForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: InputsColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: InputsColor, width: 2.0),
          ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: InputsColor, width: 2.0)
        ),
        hintText: 'Email',
      ),
        controller: controladorEmailForm,
    );
  }
}
//Widget de Input para a senha
class SenhaForm extends StatefulWidget {
  const SenhaForm({Key? key}) : super(key: key);

  @override
  _SenhaFormState createState() => _SenhaFormState();
}

//Guarda o valor do input da senha
class _SenhaFormState extends State<SenhaForm> {
//Controlador de texto que recebe o valor do input. Estatico para que haja acesso global
  static final controladorSenhaForm = TextEditingController();

  @override
  void dispose() {
    controladorSenhaForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: InputsColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: InputsColor, width: 2.0),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: InputsColor, width: 2.0)
        ),
        hintText: 'Senha',
      ),
      controller: controladorSenhaForm,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //Maneira simplificada de ocultar a action bar e a task bar
    SystemChrome.setEnabledSystemUIOverlays([]);

    //Metodo para a realizacao da requisicao de login a API
    Future<void> fetchLogin() async {
      final response = await http
          .post(Uri.parse('http://192.168.15.123:5000/api/Login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _EmailFormState.controladorEmailForm.text,
          'senha': _SenhaFormState.controladorSenhaForm.text
        }),
      );
      if (response.statusCode == 200) {
        //Mudanca de cor dos inputs de acordo com o retorno da API
        InputsColor = Color(0xff808080);
        rebuildAllChildren(context);
        //Exibicao de mensagem na tela
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sucesso!!!'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(response.body)
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        //Mudanca de cor dos inputs de acordo com o retorno da API
        InputsColor = Color(0xffFF0000);
        rebuildAllChildren(context);
        //Exibicao de mensagem na tela
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Fracasso!!!'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(response.body)
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login', style: TextStyle(fontSize: 40, color: Colors.green),),
            const SizedBox(height: 20),
            const EmailForm(),
            const SizedBox(height: 20),
            const SenhaForm(),
            const SizedBox(height: 20),
            TextButton(
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                minimumSize: MaterialStateProperty.all(Size(180, 60))
              ), onPressed: (){
                fetchLogin();
              }, child: Text('Entrar')),
            const SizedBox(height: 20),
            TextButton(
                onPressed: (){},
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                minimumSize: MaterialStateProperty.all(Size(180, 60))
            ), child: Text('Cadastre-se'))
          ],
        ),
      ),
    );
  }
  //Metodo para reconstruir os elementos em momentos de mudancas
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }
}
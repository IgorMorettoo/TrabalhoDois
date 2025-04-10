import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Request',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Buscar Usuário'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? userName;
  String? userEmail;
  String? userAvatar;
  int _counter = 0;
  final TextEditingController _idController = TextEditingController();
  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }
  Future<void> fetchUser(int id) async {
    final url = Uri.parse('https://reqres.in/api/users/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final user = data['data'];

      setState(() {
        userName = '${user['first_name']} ${user['last_name']}';
        userEmail = user['email'];
        userAvatar = user['avatar'];
      });
    } else {

      setState(() {
        userName = null;
        userEmail = null;
        userAvatar = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não encontrado!')), //erro dentro da função
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Colors.white70,
             borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: Colors.purple.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("images/user.png", height: 100, width: 150,),
                const SizedBox(height: 20),
                const Text(
                  'Digite seu ID no campo abaixo (entre 1 e 12):',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID do usuário',
                  ),
                ),
                const SizedBox(height: 20),
               SizedBox(
                 width: 150,
                  child: ElevatedButton.icon(
                    label: const Text('Buscar'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
                    onPressed: () {

                    final String inputText = _idController.text;
                    final int? id = int.tryParse(inputText);

                    if (id == null) {
                      setState(() {
                        userName = null;
                        userEmail = null;
                        userAvatar = null;
                      }); //limpar dados
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('O ID deve ser um número inteiro.')),
                      );
                      return;
                    }
                    if (id < 1 || id > 12) {
                      setState(() {
                        userName = null;
                        userEmail = null;
                        userAvatar = null;
                      }); //limpar dados
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Usuário não encontrado!')), //erro dentro do botão
                      );
                      return;
                    }
                    print('ID digitado: $id');
                    fetchUser(id);
                  },
                  )
                ),
                if (userName != null) ...[
                  const SizedBox(height: 20),
                  CircleAvatar(
                    backgroundImage: NetworkImage(userAvatar!),
                    radius: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName!,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(userEmail!),
                  //mostrar informações
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
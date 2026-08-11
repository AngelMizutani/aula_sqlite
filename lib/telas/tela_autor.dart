import 'package:flutter/material.dart';
import 'package:aula_sqlite/database/db_helper.dart';
import 'package:aula_sqlite/model/autor.dart';
import 'package:sqflite/sqflite.dart';

class TelaAutor extends StatefulWidget {
  const TelaAutor({super.key});

  @override
  State<StatefulWidget> createState() {
    return TelaAutorState();
  }
}

class TelaAutorState extends State<TelaAutor> {
  List<Autor> _autores = [];

  final _nomeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarAutores();
  }

  Future<void> _carregarAutores() async {
    final autores = await DbHelper.instance.listarAutores();
    setState(() {
      _autores = autores;
    });
  }

  Future<void> _addAutor() async {
    if (_nomeController.text.trim().isEmpty) return;

    final autor = Autor(nome: _nomeController.text.trim());
    await DbHelper.instance.addAutor(autor);
    _nomeController.clear();
    _carregarAutores();
  }

  Future<void> _excluirAutor(int id) async {
    await DbHelper.instance.excluirAutor(id);
    _carregarAutores();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Autores'),
        backgroundColor: const Color.fromARGB(255, 1, 4, 25),
        foregroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nomeController,
                    decoration: InputDecoration(hintText: 'Nome do autor'),
                  ),
                ),
                IconButton(onPressed: _addAutor, icon: Icon(Icons.add)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

// Utilizando a classe shared_preferences posso criar um CRUD bem simples
class TodoRepository {
  late SharedPreferences sharedPreferences;

  void saveTodos(List<Todo> todos) {
    final String jsonList = json.encode(todos);
    sharedPreferences.setString('lista_todos', jsonList);
  }

  Future<List<Todo>> loadTodos() async{
    sharedPreferences = await SharedPreferences.getInstance();
    String listaTodos = sharedPreferences.getString('lista_todos') ?? '[]';
    List listaJson = json.decode(listaTodos) as List;
    return listaJson.map((e) => Todo.fromJson(e)).toList();
  }
}
import 'package:flutter/material.dart';
import 'package:todo_flutter/models/todo.dart';
import 'package:todo_flutter/repositories/todo_repository.dart';
import 'package:todo_flutter/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  //Fazem a parte intermediária pra pegar os dados que o usuário passo em um campo de input
  TextEditingController tarefaController = TextEditingController();
  late TodoRepository repositorio = TodoRepository();

  List<Todo> tarefas = [];
  String? errorText;

  //metodo usado para popular a lista tarefa antes de exibir o widget (no inicio dele) e de quebra instanciar SharedPreferences
  @override
  void initState() {
    super.initState();

    repositorio.loadTodos().then((value){
      setState(() {
        tarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return todoListPage();
  }

  void adicionar() {
    String text = tarefaController.text;

    //condicional para verificar se o campo está vazio
    if (text.isEmpty) {
      setState(() {
        errorText = 'Adicione um título para a tarefa!';
      });
      return;
    }

    setState(() {
      tarefas.add(Todo(title: text, dateTime: DateTime.now()));
      errorText = null;
    });
    tarefaController.clear();
    repositorio.saveTodos(tarefas);
  }

  void removerTudo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remover Tarefas'),
        content: Text('Deseja remover todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xff00f7f3)
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                Navigator.of(context).pop();
                tarefas.clear();
                repositorio.saveTodos(tarefas);
              });
            },
            child: Text('Remover'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red
            ),
          ),
        ],
      ),
    );
  }

  void onDelete(Todo tarefa) {
    Todo tarefaDeletada = tarefa;
    int tarefaPosicao = tarefas.indexOf(tarefaDeletada);

    setState(() {
      tarefas.remove(tarefa);
    });
    repositorio.saveTodos(tarefas);

    //limpa qualquer snackBar que estiver sendo exibido antes do ultimo
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa ${tarefaDeletada.title} removida!'),
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: const Color(0xff00f7f3),
        onPressed: () {
          setState(() {
            tarefas.insert(tarefaPosicao, tarefaDeletada);
            repositorio.saveTodos(tarefas);
          });
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  Widget todoListPage() {
    //Para manter o layout seguro (não quebrar por caus de uma heigth absurdo) usar SafeArea
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Lista de Tarefas",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tarefaController,
                        decoration: InputDecoration(
                          labelText: "Adicione uma Tarefa",
                          floatingLabelStyle:
                              const TextStyle(color: Color(0xff00f7f3)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff00f7f3)),
                          ),
                          // campo errorText é para colocar uma string de erro caso alguma coisa errada aconteça
                          errorText: errorText,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: adicionar,
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(13),
                          backgroundColor: Color(0xff00f7f3)),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                //Flexible permite que ao criar varias tarefas o shrinkWrap não quebre a tela (da um limite max pra lista, se passar libera o scroll)
                Flexible(
                  //shrinkWrap: true - sempre tenha o tamanho total dos componentes filhos
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo tarefa in tarefas)
                        // ListTile pode ser uma solução de widget de itens mas é muito limitante
                        // ListTile(
                        //   title: Text(tarefa),
                        //   leading: const Icon(
                        //     Icons.save,
                        //     size: 30,
                        //   ),
                        // )
                        // utilizar um widget persolnalizado
                        TodoListItem(
                          todo: tarefa,
                          onDelete: onDelete,
                        )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${tarefas.length} tarefas pendentes',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: removerTudo,
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(13),
                          backgroundColor: Color(0xff00f7f3)),
                      child: const Text("Limpar tudo"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

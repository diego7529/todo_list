import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/todo.dart';
import 'package:lista_tarefas/repositories/todo_repository.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;
  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adicione uma tarefa',
                            hintText: 'Ex: Estudar Flutter',
                            errorText: errorText)),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'O título não pode ser vazio!';
                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14)),
                      child: Icon(Icons.add, size: 30))
                ],
              ),
              SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      TodoListIten(todo: todo, onDelete: onDelete),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child:
                        Text('Você possui ${todos.length} tarefas pendentes'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: showDeletedTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14)),
                      child: Text('Limpar Tudo'))
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa ${todo.title} foi removida com sucesso'),
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          setState(() {
            todos.insert(deletedTodoPos!, deletedTodo!);
          });
          todoRepository.saveTodoList(todos);
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showDeletedTodosConfirmationDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Limpar tudo?'),
              content:
                  Text('Você tem certeza que deseja apagar todas as tarefas?'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xff00d7f3)),
                    child: Text('Cancelar')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      deleteAllTodos();
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('Limpar tudo'))
              ],
            ));
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}

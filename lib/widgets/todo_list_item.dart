import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas/models/todo.dart';

class TodoListIten extends StatelessWidget {
  const TodoListIten({super.key, required this.todo, required this.onDelete});

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
          actionExtentRatio: 0.25,
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              color: Colors.red,
              icon: Icons.delete,
              caption: 'Deletar',
              onTap: () {
                onDelete(todo);
              },
            )
          ],
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[200],
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy - HH:mm').format(todo.time),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  todo.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )
              ],
            ),
          )),
    );
  }
}

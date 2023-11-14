import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/models/todo.dart';

class TodoListItem extends StatelessWidget {
  TodoListItem({
    super.key,
    required this.todo,
    required this.onDelete,
  });

  Todo todo;
  Function(Todo) onDelete;

  void deletar(BuildContext context) {
    onDelete(todo);
  }

  @override
  Widget build(BuildContext context) {
    return todoListItem();
  }

  Widget todoListItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.3,
          children: [
            SlidableAction(
              padding: const EdgeInsets.all(0),
              onPressed: deletar,
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Deletar',
              borderRadius: BorderRadius.circular(5),
            )
          ],
        ),
        child: Container(
          // margin do container
          // margin: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                todo.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

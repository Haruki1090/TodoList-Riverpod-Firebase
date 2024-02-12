import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_firestore/todo_list.dart';



class AddTodoDialog extends ConsumerWidget {
  AddTodoDialog({super.key});


  ///todo　newTodo を firesore に上書き（追加）-> 画面の ListView に反映
Future<void> addTodoList(TodoList newTodo) async {
    await FirebaseFirestore.instance.collection('todoList').add({
      'id': newTodo.id,
      'title': newTodo.title,
      'description': newTodo.description,
      'isCompleted': newTodo.isCompleted,
      'createdAt': newTodo.createdAt,
    });
  }

  ///Controller を２要素で与える
  final editedControllerValue_title = TextEditingController();
  final editedControllerValue_discription = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('ToDoを追加'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('タイトル'),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'タイトルを入力',
            ),
            controller:  editedControllerValue_title,
          ),
          const SizedBox(height: 8),
          const Text('詳細'),
          TextFormField(
            decoration: const InputDecoration(
              hintText: '詳細を入力',
            ),
            controller: editedControllerValue_discription,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {

            ///Todolist セットを newTodo として置き換える
            final newTodo = TodoList(
              id: DateTime.now().toString(),
              title: editedControllerValue_title.text,
              description: editedControllerValue_discription.text,
              isCompleted: false,
              createdAt: DateTime.now(),
            );

            ///todo newTodo を既存の TodoList[] に追加
            addTodoList(newTodo);
            ///画面戻る
            Navigator.pop(context);
          },
          child: const Text('追加'),
        ),
      ],
    );
  }
}
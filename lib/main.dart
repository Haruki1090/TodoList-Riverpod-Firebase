import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_firestore/todo_list.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      const ProviderScope(child: MyApp())
  );
}

///TodoListProvider
final todoListProvider = StateProvider((ref) => <TodoList>[]);



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TodoList-RiverPod-Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TodoList-RiverPod-Firebase'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('todoList').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('エラーが発生しました'));
          }

          for (var doc in snapshot.data!.docs) {
            ref.read(todoListProvider).add(
              TodoList(
                id: doc.id,
                title: doc['title'],
                description: doc['description'],
                isCompleted: doc['isCompleted'],
                createdAt: doc['createdAt'].toDate(),
              ),
            );
          }

          return ListView.builder(
            itemCount: ref.watch(todoListProvider).length,
            itemBuilder: (context, index) {
              final todo = ref.watch(todoListProvider)[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    FirebaseFirestore.instance.collection('todoList').doc(todo.id).delete();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}



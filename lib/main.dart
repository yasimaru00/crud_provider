import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_provider/page/updatetask.dart';
import 'package:crud_provider/service/tasklist.dart';
import 'package:sqflite/sqlite_api.dart';

import 'page/addtask.dart';
import 'page/listpage.dart';
import 'models/task.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Tasklist>(
          create: (context) => Tasklist(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => const MyListPage(),
        "/addTask": (context) => AddTaskPage(),
        "/updatetask": (context) => const EditTaskPage(),
      },
      initialRoute: "/",
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

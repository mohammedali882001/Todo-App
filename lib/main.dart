// by mohamed ali

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/myBlocObserver%20.dart';

import 'layout/todo_app/todo_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const Todo());
}

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoLayout(),
    );
  }
}

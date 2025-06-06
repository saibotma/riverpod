// ignore_for_file: avoid_print, avoid_unused_constructor_parameters

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class Todo {
  Todo.fromJson(Object obj);
}

class Http {
  Future<List<Object>> get(String str) async => [str];
}

final http = Http();

/* SNIPPET START */
class AsyncTodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  FutureOr<List<Todo>> build() async {
    final json = await http.get('api/todos');

    return [...json.map(Todo.fromJson)];
  }

  // ...
}

final asyncTodosNotifier =
    AsyncNotifierProvider<AsyncTodosNotifier, List<Todo>>(
  AsyncTodosNotifier.new,
);

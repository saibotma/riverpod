// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'reading_counter.dart';

/* SNIPPET START */

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HookConsumerWidget позволяет использовать хуки внутри метода build
    final state = useState(0);

    // Также мы можем использовать ref для прослушивания провайдеров.
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}

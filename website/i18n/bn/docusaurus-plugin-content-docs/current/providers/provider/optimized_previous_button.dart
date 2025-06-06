// A provider that controls the current page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/* SNIPPET START */

final pageIndexProvider = StateProvider<int>((ref) => 0);

// একটি প্রভাইডার যা ব্যবহারকারীকে পূর্ববর্তী পৃষ্ঠায় যাওয়ার অনুমতি দেওয়া হয়েছে কিনা তা গণনা করে
/* highlight-start */
final canGoToPreviousPageProvider = Provider<bool>((ref) {
/* highlight-end */
  return ref.watch(pageIndexProvider) == 0;
});

class PreviousButton extends ConsumerWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // আমরা এখন আমাদের নতুন প্রভাইডার দেখতেছি
    // আমাদের উইজেট আর হিসাব করছে না আমরা আগের পৃষ্ঠায় যেতে পারব কিনা।
/* highlight-start */
    final canGoToPreviousPage = ref.watch(canGoToPreviousPageProvider);
/* highlight-end */

    void goToPreviousPage() {
      ref.read(pageIndexProvider.notifier).update((state) => state - 1);
    }

    return ElevatedButton(
      onPressed: canGoToPreviousPage ? goToPreviousPage : null,
      child: const Text('previous'),
    );
  }
}

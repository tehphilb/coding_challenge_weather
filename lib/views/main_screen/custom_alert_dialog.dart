import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CuAlertDialog extends ConsumerWidget {
  const CuAlertDialog({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

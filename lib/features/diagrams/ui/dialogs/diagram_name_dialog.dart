import 'package:flutter/material.dart';

class DiagramNameDialog extends StatefulWidget {
  const DiagramNameDialog({required this.initialName, super.key});

  static Future<String?> show(BuildContext context, {String? initialName}) {
    return showDialog<String>(
      context: context,
      builder: (_) => DiagramNameDialog(initialName: initialName),
    );
  }

  final String? initialName;

  @override
  State<DiagramNameDialog> createState() => _DiagramNameDialogState();
}

class _DiagramNameDialogState extends State<DiagramNameDialog> {
  late final _controller = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final isRename = widget.initialName != null;
    return AlertDialog(
      title: Text(isRename ? 'Rename diagram' : 'New diagram'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: 'Diagram name'),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          child: Text(isRename ? 'Rename' : 'Create'),
        ),
      ],
    );
  }
}

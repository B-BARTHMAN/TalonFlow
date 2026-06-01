import 'package:flutter/material.dart';

/// A single-field dialog for entering or editing a name. Returns the trimmed
/// value, or null if cancelled or left empty.
class NameInputDialog extends StatefulWidget {
  const NameInputDialog({
    required this.title,
    this.initialValue,
    this.hintText = 'Name',
    this.confirmLabel = 'OK',
    super.key,
  });

  static Future<String?> show(
    BuildContext context, {
    required String title,
    String? initialValue,
    String hintText = 'Name',
    String confirmLabel = 'OK',
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => NameInputDialog(
        title: title,
        initialValue: initialValue,
        hintText: hintText,
        confirmLabel: confirmLabel,
      ),
    );
  }

  final String title;
  final String? initialValue;
  final String hintText;
  final String confirmLabel;

  @override
  State<NameInputDialog> createState() => _NameInputDialogState();
}

class _NameInputDialogState extends State<NameInputDialog> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(hintText: widget.hintText),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_cubit.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  Future<void> _onNewDiagram(BuildContext context) async {
    final cubit = context.read<DiagramListCubit>();
    final name = await _showNameDialog(context);
    if (name != null && name.trim().isNotEmpty) {
      await cubit.createDiagram(name.trim());
    }
  }

  Future<String?> _showNameDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Diagram'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Diagram name'),
          textCapitalization: TextCapitalization.words,
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: FilledButton.tonalIcon(
        onPressed: () => _onNewDiagram(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Diagram'),
      ),
    );
  }
}

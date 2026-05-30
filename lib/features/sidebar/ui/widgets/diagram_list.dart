// lib/features/sidebar/ui/widgets/diagram_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talonflow/core/models/diagram.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_cubit.dart';
import 'package:talonflow/features/diagrams/cubit/diagram_list_state.dart';

class DiagramList extends StatelessWidget {
  const DiagramList({super.key});

  Future<void> _onRename(BuildContext context, Diagram diagram) async {
    final cubit = context.read<DiagramListCubit>();
    final name = await _showRenameDialog(context, diagram.name);
    if (name != null && name.trim().isNotEmpty) {
      await cubit.renameDiagram(diagram.id, name.trim());
    }
  }

  Future<String?> _showRenameDialog(BuildContext context, String current) {
    final controller = TextEditingController(text: current);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Diagram'),
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
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  Future<void> _onDelete(BuildContext context, Diagram diagram) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Diagram'),
        content: Text('Delete "${diagram.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await context.read<DiagramListCubit>().deleteDiagram(diagram.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiagramListCubit, DiagramListState>(
      builder: (context, state) => switch (state.status) {
        DiagramListStatus.initial || DiagramListStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
        DiagramListStatus.error => Center(
          child: Text(
            state.error ?? 'Something went wrong',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        DiagramListStatus.loaded when state.diagrams.isEmpty => _EmptyState(),
        DiagramListStatus.loaded => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.diagrams.length,
          itemBuilder: (context, i) {
            final diagram = state.diagrams[i];
            return _DiagramTile(
              name: diagram.name,
              onTap: () {},
              onRename: () => _onRename(context, diagram),
              onDelete: () => _onDelete(context, diagram),
            );
          },
        ),
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.account_tree_outlined, color: colors.outlineVariant),
          const SizedBox(height: 8),
          Text(
            'No diagrams yet',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.outline),
          ),
        ],
      ),
    );
  }
}

class _DiagramTile extends StatelessWidget {
  const _DiagramTile({
    required this.name,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  final String name;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.account_tree_outlined),
      title: Text(name),
      onTap: onTap,
      trailing: PopupMenuButton<_TileAction>(
        onSelected: (action) => switch (action) {
          _TileAction.rename => onRename(),
          _TileAction.delete => onDelete(),
        },
        itemBuilder: (_) => const [
          PopupMenuItem(
            value: _TileAction.rename,
            child: Text('Rename'),
          ),
          PopupMenuItem(
            value: _TileAction.delete,
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

enum _TileAction { rename, delete }

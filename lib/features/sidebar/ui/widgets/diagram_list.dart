import 'package:flutter/material.dart';

class DiagramList extends StatelessWidget {
  const DiagramList({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder — will be replaced with BLoC-driven list in the next step
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_tree_outlined,
            color: colors.outlineVariant,
          ),
          const SizedBox(height: 10),
          Text(
            'No diagrams yet',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.outline,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DiagramListEmpty extends StatelessWidget {
  const DiagramListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.account_tree_outlined, color: colors.outlineVariant),
          const SizedBox(height: 8),
          Text(
            'No diagrams yet',
            style: textTheme.bodySmall?.copyWith(color: colors.outline),
          ),
        ],
      ),
    );
  }
}

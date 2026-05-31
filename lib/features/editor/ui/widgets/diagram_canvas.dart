import 'package:flutter/material.dart';

class DiagramCanvas extends StatelessWidget {
  const DiagramCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InteractiveViewer(
      minScale: 0.25,
      maxScale: 4,
      child: SizedBox.expand(
        child: Center(
          child: Text(
            'Diagram Canvas',
            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:talonflow/features/diagrams/ui/diagram_list.dart';
import 'package:talonflow/features/diagrams/ui/widgets/new_diagram_button.dart';

class DiagramsDrawer extends StatelessWidget {
  const DiagramsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Diagrams',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Divider(height: 1, color: colors.outlineVariant),
            const Expanded(child: DiagramList()),
            Divider(height: 1, color: colors.outlineVariant),
            const Padding(
              padding: EdgeInsets.all(12),
              child: NewDiagramButton(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:talonflow/features/diagrams/ui/widgets/new_diagram_button.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: SizedBox(width: double.infinity, child: NewDiagramButton()),
    );
  }
}

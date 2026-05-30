import 'package:flutter/material.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: FilledButton.tonalIcon(
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Diagram'),
      ),
    );
  }
}

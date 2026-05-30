import 'package:flutter/material.dart';
import 'package:talonflow/features/sidebar/ui/widgets/diagram_list.dart';
import 'package:talonflow/features/sidebar/ui/widgets/sidebar_footer.dart';
import 'package:talonflow/features/sidebar/ui/widgets/sidebar_header.dart';

class SidebarCard extends StatelessWidget {
  const SidebarCard({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 260,
      child: Material(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        elevation: 3,
        shadowColor: colors.shadow.withAlpha(102),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SidebarHeader(onClose: onClose),
            Divider(height: 1, color: colors.outlineVariant),
            const Expanded(child: DiagramList()),
            Divider(height: 1, color: colors.outlineVariant),
            const SidebarFooter(),
          ],
        ),
      ),
    );
  }
}

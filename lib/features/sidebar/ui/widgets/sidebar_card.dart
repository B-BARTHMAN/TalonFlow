import 'package:flutter/material.dart';
import 'package:talonflow/features/diagrams/ui/diagram_list.dart';
import 'package:talonflow/features/sidebar/ui/widgets/sidebar_footer.dart';
import 'package:talonflow/features/sidebar/ui/widgets/sidebar_header.dart';

class SidebarCard extends StatelessWidget {
  const SidebarCard({required this.onClose, super.key});

  static const _maxWidth = 320;

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final width = (MediaQuery.sizeOf(context).width * 0.8)
        .clamp(0.0, _maxWidth)
        .toDouble();
    
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: width,
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
      ),
    );
  }
}

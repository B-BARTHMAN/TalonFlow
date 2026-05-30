import 'package:flutter/material.dart';
import 'package:talonflow/features/sidebar/ui/widgets/sidebar_card.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({required this.isOpen, required this.onClose, super.key});

  final bool isOpen;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isOpen,
      child: AnimatedSlide(
        offset: isOpen ? Offset.zero : const Offset(-1.2, 0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SidebarCard(onClose: onClose),
        ),
      ),
    );
  }
}

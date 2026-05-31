import 'package:flutter/material.dart';
import 'package:talonflow/features/sidebar/ui/widgets/sidebar_card.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({required this.isOpen, required this.onClose, super.key});

  final bool isOpen;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scrim = Theme.of(context).colorScheme.scrim;
    return Stack(
      children: [
        if (isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: ColoredBox(color: scrim.withAlpha(115)),
            ),
          ),

        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: !isOpen,
            child: AnimatedSlide(
              offset: isOpen ? Offset.zero : const Offset(-1.2, 0),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: SafeArea(child: SidebarCard(onClose: onClose)),
            ),
          ),
        ),
      ],
    );
  }
}

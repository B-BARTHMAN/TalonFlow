import 'package:flutter/material.dart';
import 'package:talonflow/features/sidebar/ui/widgets/sidebar_card.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({required this.isOpen, required this.onClose, super.key});

  static const _duration = Duration(milliseconds: 250);

  final bool isOpen;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scrim = Theme.of(context).colorScheme.scrim;
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !isOpen,
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: AnimatedOpacity(
                opacity: isOpen ? 1 : 0,
                duration: _duration,
                child: ColoredBox(color: scrim.withAlpha(115)),
              ),
            ),
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
              duration: _duration,
              curve: Curves.easeOut,
              child: SafeArea(child: SidebarCard(onClose: onClose)),
            ),
          ),
        ),
      ],
    );
  }
}

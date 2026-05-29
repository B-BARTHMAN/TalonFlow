import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({required this.isOpen, super.key});

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      left: isOpen ? 16 : -200,
      top: 16,
      bottom: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:talonflow/features/sidebar/ui/widgets/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _sidebarOpen = false;

  void _toggleSidebar() => setState(() => _sidebarOpen = !_sidebarOpen);
  void _closeSidebar() => setState(() => _sidebarOpen = false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: _toggleSidebar,
              icon: const Icon(Icons.menu_rounded),
            ),
          ),
          body: const Placeholder(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),

        // Overlay — tap to dismiss. Conditional so it's not in the hit-test
        // tree at all when the sidebar is closed.
        if (_sidebarOpen)
          GestureDetector(
            onTap: _closeSidebar,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.black54),
          ),

        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Sidebar(isOpen: _sidebarOpen, onClose: _closeSidebar),
        ),
      ],
    );
  }
}

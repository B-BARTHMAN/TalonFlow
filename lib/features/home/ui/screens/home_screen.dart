import 'package:flutter/material.dart';
import 'package:talonflow/features/editor/ui/widgets/diagram_canvas.dart';
import 'package:talonflow/features/sidebar/ui/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _sidebarOpen = false;

  void _openSidebar() => setState(() => _sidebarOpen = true);
  void _closeSidebar() => setState(() => _sidebarOpen = false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: _openSidebar,
              icon: const Icon(Icons.menu_rounded),
            ),
          ),
          body: const DiagramCanvas(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
        Sidebar(isOpen: _sidebarOpen, onClose: _closeSidebar),
      ],
    );
  }
}

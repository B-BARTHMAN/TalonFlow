import 'package:flutter/material.dart';
import 'package:talonflow/features/home/ui/widgets/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _sidebarOpen = false;

  void _toggleSidebar() {
    setState(() {
      _sidebarOpen = !_sidebarOpen;
    });
  }

  void _closeSidebar() {
    setState(() {
      _sidebarOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: _toggleSidebar,
              icon: const Icon(Icons.menu),
            ),
          ),
          body: const Placeholder(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),

        // Dark Overlay
        if (_sidebarOpen)
          GestureDetector(
            onTap: _closeSidebar,
            child: Container(
              color: Colors.black54,
            ),
          ),

        // Sidebar
        SideBar(isOpen: _sidebarOpen),
      ],
    );
  }
}

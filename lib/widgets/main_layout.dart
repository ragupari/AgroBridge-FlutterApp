import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late List<String> _routes;
  late List<BottomNavigationBarItem> _navItems;
  bool isFarmer = false;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final type = prefs.getString('userType') ?? 'user';

    setState(() {
      isFarmer = type == 'farmer';
      _routes = isFarmer
          ? ['/home', '/status', '/sell-product', '/cart', '/settings']
          : ['/home', '/status', '/cart', '/settings'];

      _navItems = isFarmer
          ? const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Status'),
              BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sell'),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ]
          : const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Status'),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ];
    });
  }

  void _onTabTapped(BuildContext context, int index) {
    if (_routes[index] != _routes[widget.currentIndex]) {
      Navigator.pushReplacementNamed(context, _routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_routes == null || _navItems == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[800],
        title: const Text('AgroBridge', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              await Navigator.pushNamed(context, '/profile'); // WAIT for return
              _loadUserType(); // reload role + bottom bar
            },
          ),
        ],
      ),
      body: SafeArea(child: widget.child),
      bottomNavigationBar: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: BottomNavigationBar(
          key: ValueKey(_navItems.length),
          currentIndex: widget.currentIndex,
          onTap: (index) => _onTabTapped(context, index),
          selectedItemColor: Colors.green[800],
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: _navItems,
        ),
      ),
    );
  }
}

import 'package:bela_blok/screens/games_screen.dart';
import 'package:bela_blok/screens/players_screen.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<StatefulWidget> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<String> _titles = ["Partije", "Igrači"];
  final List<Widget> _screens = [GamesScreen(), PlayersScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          //TODO: Dovrsit settingse, proslijedit _toggleTheme
          IconButton(onPressed: () => {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(
              Icons.sports_esports,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            label: "Partije",
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outlined),
            selectedIcon: Icon(
              Icons.people,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            label: "Igrači",
          ),
        ],
      ),
    );
  }
}

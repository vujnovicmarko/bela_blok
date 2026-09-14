import 'package:bela_blok/screens/base_screen.dart';
import 'package:bela_blok/screens/games_screen.dart';
import 'package:bela_blok/screens/players_screen.dart';
import 'package:bela_blok/widgets/settings_menu.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const MainNavigation({super.key, required this.onThemeToggle});

  @override
  State<StatefulWidget> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<BaseScreen> _screens = [GamesScreen(), PlayersScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _screens[_currentIndex].getTitle(context),
        actions: [
          IconButton(
            onPressed: () {
              showSettingsMenu(context, onThemeToggle: widget.onThemeToggle);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(child: _screens[_currentIndex]),
      floatingActionButton: _screens[_currentIndex].getFloatingActionButton(
        context,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        //TODO: mozda dodat animacije za gumbe da se nakratko povecaju
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

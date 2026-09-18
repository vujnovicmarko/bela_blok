import 'package:bela_blok/screens/games_screen.dart';
import 'package:bela_blok/screens/players_screen.dart';
import 'package:bela_blok/widgets/bounce_icon.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const MainNavigation({super.key, required this.onThemeToggle});

  @override
  State<StatefulWidget> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  List<Widget> get _screens => [
    GamesScreen(onThemeToggle: widget.onThemeToggle),
    PlayersScreen(onThemeToggle: widget.onThemeToggle),
  ];

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndexNotifier.value]),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _currentIndexNotifier,
        builder: (context, currentIndex, child) {
          return NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndexNotifier.value = index;
              });
            },
            indicatorColor: Theme.of(context).colorScheme.primaryContainer,
            destinations: [
              NavigationDestination(
                icon: BounceIcon(
                  icon: Icons.sports_esports_outlined,
                  index: 0,
                  selectedIndexNotifier: _currentIndexNotifier,
                ),
                selectedIcon: BounceIcon(
                  icon: Icons.sports_esports,
                  index: 0,
                  selectedIndexNotifier: _currentIndexNotifier,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                label: "Partije",
              ),
              NavigationDestination(
                icon: BounceIcon(
                  icon: Icons.people_outlined,
                  index: 1,
                  selectedIndexNotifier: _currentIndexNotifier,
                ),
                selectedIcon: BounceIcon(
                  icon: Icons.people,
                  index: 1,
                  selectedIndexNotifier: _currentIndexNotifier,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                label: "Igrači",
              ),
            ],
          );
        },
      ),
    );
  }
}

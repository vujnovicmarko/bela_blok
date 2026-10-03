import 'package:bela_blok/screens/games_screen.dart';
import 'package:bela_blok/screens/players_screen.dart';
import 'package:bela_blok/widgets/bounce_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainNavigation extends StatefulWidget {
  final void Function() onThemeToggle;

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
                  icon: Symbols.sports_esports_rounded,
                  fill: 0,
                  index: 0,
                  selectedIndexNotifier: _currentIndexNotifier,
                ),
                selectedIcon: BounceIcon(
                  icon: Symbols.sports_esports_rounded,
                  fill: 1,
                  index: 0,
                  selectedIndexNotifier: _currentIndexNotifier,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                label: "Partije",
              ),
              NavigationDestination(
                icon: BounceIcon(
                  icon: Symbols.people_rounded,
                  fill: 0,
                  index: 1,
                  selectedIndexNotifier: _currentIndexNotifier,
                ),
                selectedIcon: BounceIcon(
                  icon: Symbols.people_rounded,
                  fill: 1,
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

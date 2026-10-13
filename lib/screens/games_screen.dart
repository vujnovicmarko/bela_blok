import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/screens/game_screen.dart';
import 'package:bela_blok/services/app_preferences.dart';
import 'package:bela_blok/widgets/empty_screen_placeholder.dart';
import 'package:bela_blok/widgets/expandable_section_header.dart';
import 'package:bela_blok/widgets/game_card.dart';
import 'package:bela_blok/widgets/settings_menu.dart';
import 'package:bela_blok/widgets/start_game_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_symbols_icons/symbols.dart';

class GamesScreen extends StatefulWidget {
  final void Function() onThemeToggle;

  const GamesScreen({super.key, required this.onThemeToggle});

  @override
  State<StatefulWidget> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  List<Game> _activeGames = [];
  List<Game> _finishedGames = [];

  bool _isActiveGamesExpanded = AppPreferences.defaultIsActiveGamesExpanded;
  bool _isFinishedGamesExpanded = AppPreferences.defaultIsFinishedGamesExpanded;

  bool _isLoading = false;
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (_activeGames.isEmpty && _finishedGames.isEmpty) {
      setState(() {
        _isLoading = true;
      });
    }

    final isActiveGamesExpanded =
        await AppPreferences.getIsActiveGamesExpanded();
    final isFinishedGamesExpanded =
        await AppPreferences.getIsFinishedGamesExpanded();
    final activeGames = await DatabaseHelper.instance.getActiveGames();
    final finishedGames = await DatabaseHelper.instance.getFinishedGames();

    if (!mounted) return;

    setState(() {
      _isActiveGamesExpanded = isActiveGamesExpanded;
      _isFinishedGamesExpanded = isFinishedGamesExpanded;
      _activeGames = activeGames;
      _finishedGames = finishedGames;
      _isLoading = false;
    });
  }

  Future<void> loadGames() async {
    final activeGames = await DatabaseHelper.instance.getActiveGames();
    final finishedGames = await DatabaseHelper.instance.getFinishedGames();

    if (!mounted) return;

    setState(() {
      _activeGames = activeGames;
      _finishedGames = finishedGames;
    });
  }

  Future<void> _toggleIsActiveGamesExpanded() async {
    final newIsActiveGamesExpanded = !_isActiveGamesExpanded;

    setState(() {
      _isActiveGamesExpanded = newIsActiveGamesExpanded;
    });

    await AppPreferences.setIsActiveGamesExpanded(newIsActiveGamesExpanded);
  }

  Future<void> _toggleIsFinishedGamesExpanded() async {
    final newIsFinishedGamesExpanded = !_isFinishedGamesExpanded;

    setState(() {
      _isFinishedGamesExpanded = newIsFinishedGamesExpanded;
    });

    await AppPreferences.setIsFinishedGamesExpanded(newIsFinishedGamesExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Partije"),
        actions: [
          IconButton(
            onPressed: () => showSettingsMenu(
              context,
              onThemeToggle: widget.onThemeToggle,
              onAllDataDeleted: loadGames,
            ),
            icon: Icon(Symbols.settings_rounded, fill: isDarkMode ? 1 : 0),
          ),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
        child: FloatingActionButton(
          onPressed: _openStartGameDialog,
          child: const Icon(Symbols.add_rounded, fill: 1),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse &&
              _isFabVisible) {
            setState(() {
              _isFabVisible = false;
            });
          } else if (notification.direction == ScrollDirection.forward &&
              !_isFabVisible) {
            setState(() {
              _isFabVisible = true;
            });
          }
          return true;
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_activeGames.isEmpty && _finishedGames.isEmpty) {
      return EmptyScreenPlaceholder(
        icon: Symbols.playing_cards_rounded,
        title: "Nema odigranih partija",
        subtitle: TextSpan(
          children: [
            const TextSpan(text: "Pritisni "),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(Symbols.add_rounded, fill: 1),
              ),
            ),
            const TextSpan(text: " za početak partije"),
          ],
        ),
        onRefresh: loadGames,
      );
    }

    return RefreshIndicator(
      onRefresh: loadGames,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    if (_activeGames.isNotEmpty) _buildActiveGames(),
                    if (_activeGames.isNotEmpty && _finishedGames.isNotEmpty)
                      const SizedBox(height: 20),
                    if (_finishedGames.isNotEmpty) _buildFinishedGames(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveGames() {
    return Column(
      children: [
        ExpandableSectionHeader(
          title: "Aktivne Partije",
          isExpanded: _isActiveGamesExpanded,
          onTap: _toggleIsActiveGamesExpanded,
        ),
        if (_isActiveGamesExpanded)
          ListView.builder(
            itemCount: _activeGames.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final game = _activeGames[index];
              return GameCard(game: game, loadGames: loadGames);
            },
          ),
      ],
    );
  }

  Widget _buildFinishedGames() {
    return Column(
      children: [
        ExpandableSectionHeader(
          title: "Završene Partije",
          isExpanded: _isFinishedGamesExpanded,
          onTap: _toggleIsFinishedGamesExpanded,
        ),
        if (_isFinishedGamesExpanded)
          ListView.builder(
            itemCount: _finishedGames.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final game = _finishedGames[index];
              return GameCard(game: game, loadGames: loadGames);
            },
          ),
      ],
    );
  }

  void _openStartGameDialog() async {
    final Game? createdGame = await showStartGameDialog(context);

    if (createdGame != null && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameScreen(game: createdGame)),
      );

      await loadGames();
    }
  }
}

import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/widgets/empty_screen_placeholder.dart';
import 'package:bela_blok/widgets/expandable_section_header.dart';
import 'package:bela_blok/widgets/game_card.dart';
import 'package:bela_blok/widgets/settings_menu.dart';
import 'package:bela_blok/widgets/start_game_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GamesScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const GamesScreen({super.key, required this.onThemeToggle});

  @override
  State<StatefulWidget> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  List<Game> _activeGames = [];
  List<Game> _finishedGames = [];
  bool _isLoading = false;
  bool _isFabVisible = true;
  bool _isActiveGamesExpanded = true;
  bool _isFinishedGamesExpanded = false;

  @override
  void initState() {
    super.initState();
    loadGames();
  }

  Future<void> loadGames() async {
    setState(() {
      _isLoading = true;
    });

    final activeGames = await DatabaseHelper.instance.getActiveGames();
    final finishedGames = await DatabaseHelper.instance.getFinishedGames();

    setState(() {
      _activeGames = activeGames;
      _finishedGames = finishedGames;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
        child: FloatingActionButton(
          onPressed: _openStartGameDialog,
          child: const Icon(Icons.add),
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
        icon: Icons.sports_esports,
        title: "Nema odigranih partija",
        subtitle: TextSpan(
          children: [
            const TextSpan(text: "Pritisni "),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(Icons.add),
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
          onTap: () => setState(() {
            _isActiveGamesExpanded = !_isActiveGamesExpanded;
          }),
        ),
        if (_isActiveGamesExpanded)
          ListView.builder(
            itemCount: _activeGames.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final game = _activeGames[index];
              return GameCard(game: game, loadData: loadGames);
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
          onTap: () => setState(() {
            _isFinishedGamesExpanded = !_isFinishedGamesExpanded;
          }),
        ),
        if (_isFinishedGamesExpanded)
          ListView.builder(
            itemCount: _finishedGames.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final game = _finishedGames[index];
              return GameCard(game: game, loadData: loadGames);
            },
          ),
      ],
    );
  }

  void _openStartGameDialog() async {
    await showStartGameDialog(context);
    loadGames();
  }
}

import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/widgets/add_player_dialog.dart';
import 'package:bela_blok/widgets/empty_screen_placeholder.dart';
import 'package:bela_blok/widgets/player_card.dart';
import 'package:bela_blok/widgets/settings_menu.dart';
import 'package:flutter/material.dart';

class PlayersScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const PlayersScreen({super.key, required this.onThemeToggle});

  @override
  State<StatefulWidget> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  List<Map<String, dynamic>> _players = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final data = await DatabaseHelper.instance.getPlayers();

    setState(() {
      _players = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Igrači"),
        actions: [
          IconButton(
            onPressed: () =>
                showSettingsMenu(context, onThemeToggle: widget.onThemeToggle),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddPlayerDialog(context),
        child: const Icon(Icons.person_add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_players.isEmpty) {
      return EmptyScreenPlaceholder(
        icon: Icons.people,
        title: "Nema dodanih igrača",
        subtitle: TextSpan(
          children: [
            const TextSpan(text: "Pritisni "),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(Icons.person_add),
              ),
            ),
            const TextSpan(text: " za dodavanje igrača"),
          ],
        ),
        onRefresh: _loadData,
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadData(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _players.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final player = _players[index];

          return PlayerCard(
            playerName: player['name'],
            numGamesPlayed: player['numGamesPlayed'] ?? 0,
            numWins: player['numWins'] ?? 0,
          );
        },
      ),
    );
  }
}

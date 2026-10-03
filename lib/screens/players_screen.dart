import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/player.dart';
import 'package:bela_blok/widgets/add_player_dialog.dart';
import 'package:bela_blok/widgets/empty_screen_placeholder.dart';
import 'package:bela_blok/widgets/player_card.dart';
import 'package:bela_blok/widgets/settings_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayersScreen extends StatefulWidget {
  final void Function() onThemeToggle;

  const PlayersScreen({super.key, required this.onThemeToggle});

  @override
  State<StatefulWidget> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  List<Player> _players = [];
  bool _isLoading = false;
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    if (_players.isEmpty) {
      setState(() {
        _isLoading = true;
      });
    }

    final players = await DatabaseHelper.instance.getPlayers();

    setState(() {
      _players = players;
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
            onPressed: () => showSettingsMenu(
              context,
              onThemeToggle: widget.onThemeToggle,
              onAllDataDeleted: loadPlayers,
            ),
            icon: const Icon(Symbols.settings_rounded, fill: 1),
          ),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
        child: FloatingActionButton(
          onPressed: _openAddPlayerDialog,
          child: const Icon(Symbols.person_add_rounded, fill: 1),
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

    if (_players.isEmpty) {
      return EmptyScreenPlaceholder(
        icon: Symbols.people_rounded,
        title: "Nema dodanih igrača",
        subtitle: TextSpan(
          children: [
            const TextSpan(text: "Pritisni "),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(Symbols.person_add_rounded, fill: 1),
              ),
            ),
            const TextSpan(text: " za dodavanje igrača"),
          ],
        ),
        onRefresh: loadPlayers,
      );
    }

    return RefreshIndicator(
      onRefresh: loadPlayers,
      child: ListView.builder(
        itemCount: _players.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final player = _players[index];
          return PlayerCard(player: player, loadPlayers: loadPlayers);
        },
      ),
    );
  }

  void _openAddPlayerDialog() async {
    final bool? isAdded = await showAddPlayerDialog(context);

    if (isAdded == true && mounted) {
      await loadPlayers();
    }
  }
}

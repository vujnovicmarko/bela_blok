import 'package:bela_blok/widgets/delete_player_dialog.dart';
import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final int id;
  final String playerName;
  final int numGamesPlayed;
  final int numWins;
  final VoidCallback loadData;

  const PlayerCard({
    super.key,
    required this.id,
    required this.playerName,
    required this.numGamesPlayed,
    required this.numWins,
    required this.loadData,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 12),
        title: Text(playerName),
        subtitle: Text("Partije: $numGamesPlayed   Pobjede: $numWins"),
        trailing: IconButton(
          onPressed: () =>
              _openDeletePlayerDialog(context, id, playerName, numGamesPlayed),
          icon: Icon(Icons.delete_outline, color: colorScheme.error),
        ),
      ),
    );
  }

  void _openDeletePlayerDialog(
    BuildContext context,
    int id,
    String playerName,
    int numGamesPlayed,
  ) async {
    //TODO: obrisat sve igre u kojima je sudjelovao iz baze podataka
    await showDeletePlayerDialog(context, id, playerName, numGamesPlayed);
    loadData();
  }
}

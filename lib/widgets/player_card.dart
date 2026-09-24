import 'package:bela_blok/models/player.dart';
import 'package:bela_blok/widgets/delete_player_dialog.dart';
import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final VoidCallback loadData;

  const PlayerCard({super.key, required this.player, required this.loadData});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 8),
        title: Text(player.name),
        subtitle: Text(
          "Partije: ${player.numGamesPlayed}   Pobjede: ${player.numWins}   Zvanja: ${player.totalMelds}",
        ),
        trailing: IconButton(
          onPressed: () => _openDeletePlayerDialog(context, player),
          icon: Icon(Icons.delete_outline, color: colorScheme.error),
        ),
      ),
    );
  }

  void _openDeletePlayerDialog(BuildContext context, Player player) async {
    // NOTE: provjerit jel se brisu sve igre u kojima je igrac sudjelovao
    await showDeletePlayerDialog(context, player);
    loadData();
  }
}

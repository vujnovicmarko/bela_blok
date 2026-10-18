import 'package:bela_blok/models/player.dart';
import 'package:bela_blok/widgets/delete_player_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final Future<void> Function() loadPlayers;

  const PlayerCard({
    super.key,
    required this.player,
    required this.loadPlayers,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 8),
        title: Text(player.name),
        subtitle: Row(
          children: [
            Text("Partije: ${player.numGamesPlayed}"),
            const SizedBox(width: 12),
            Text("Postotak pobjeda: ${player.winPercentage}"),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _openDeletePlayerDialog(context, player),
          icon: Icon(Symbols.delete_rounded, fill: 0, color: colorScheme.error),
        ),
      ),
    );
  }

  void _openDeletePlayerDialog(BuildContext context, Player player) async {
    final bool? isDeleted = await showDeletePlayerDialog(context, player);

    if (isDeleted == true && context.mounted) {
      await loadPlayers();
    }
  }
}

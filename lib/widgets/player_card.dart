import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String playerName;
  final int numGamesPlayed;
  final int numWins;

  const PlayerCard({
    super.key,
    required this.playerName,
    required this.numGamesPlayed,
    required this.numWins,
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
          //TODO: obrisat igraca i sve igre u kojima je sudjelovao iz baze podataka
          onPressed: () {},
          icon: Icon(Icons.delete_outline, color: colorScheme.error),
        ),
      ),
    );
  }
}

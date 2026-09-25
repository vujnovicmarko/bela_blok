import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/widgets/delete_game_dialog.dart';
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback loadData;

  const GameCard({super.key, required this.game, required this.loadData});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final parsedDateTime = DateTime.parse(game.updatedAt);

    String formattedDateTime =
        "${parsedDateTime.hour.toString().padLeft(2, '0')}:${parsedDateTime.minute.toString().padLeft(2, '0')}   "
        "${parsedDateTime.day.toString().padLeft(2, '0')}.${parsedDateTime.month.toString().padLeft(2, '0')}.${parsedDateTime.year.toString()}.";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDateTime),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "${game.player1.name} & ${game.player3.name}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${game.team1Points}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text("vs", style: const TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  children: [
                    Text(
                      "${game.player2.name} & ${game.player4.name}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${game.team2Points}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24, indent: 8, endIndent: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onError,
                    backgroundColor: colorScheme.error,
                  ),
                  onPressed: () => _openDeleteGameDialog(context, game),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text("Obriši"),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onPrimary,
                    backgroundColor: colorScheme.primary,
                  ),
                  onPressed: () => {},
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: game.isFinished
                      ? const Text("Pregledaj")
                      : const Text("Nastavi"),
                  iconAlignment: IconAlignment.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDeleteGameDialog(BuildContext context, Game game) async {
    // NOTE: treba i obrisat sve runde i zvanja iz partije
    await showDeleteGameDialog(context, game);
    loadData();
  }
}

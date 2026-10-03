import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/screens/game_screen.dart';
import 'package:bela_blok/widgets/delete_game_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final Future<void> Function() loadGames;

  const GameCard({super.key, required this.game, required this.loadGames});

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
              children: [
                Expanded(
                  child: Column(
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
                ),
                Text("vs", style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Column(
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
                  icon: const Icon(Symbols.delete_rounded, fill: 0),
                  label: const Text("Obriši"),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onPrimary,
                    backgroundColor: colorScheme.primary,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(game: game),
                      ),
                    );

                    loadGames();
                  },
                  icon: const Icon(Symbols.arrow_forward_rounded, fill: 0),
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
    final bool? isDeleted = await showDeleteGameDialog(context, game);

    if (isDeleted == true && context.mounted) {
      await loadGames();
    }
  }
}

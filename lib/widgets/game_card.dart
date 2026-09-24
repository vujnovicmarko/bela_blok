import 'package:bela_blok/models/game.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            game.player1.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            game.player3.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${game.team1Points}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "×",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            game.player2.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            game.player4.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${game.team2Points}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(formattedDateTime),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(onPressed: () {}, child: const Text("Nastavi")),
                IconButton(
                  onPressed: () => _openDeleteGameDialog(context, game),
                  icon: Icon(Icons.delete_outlined, color: colorScheme.error),
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
    // await showDeleteGameDialog(context, game);
    loadData();
  }
}

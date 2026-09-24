import 'package:bela_blok/models/game.dart';
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback loadData;

  const GameCard({super.key, required this.game, required this.loadData});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${game.player1.name} & ${game.player3.name}"),
                            Text("${game.team1Points}"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${game.player2.name} & ${game.player4.name}"),
                            Text("${game.team2Points}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(game.updatedAt),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(onPressed: () => {}, child: const Text("Nastavi")),
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

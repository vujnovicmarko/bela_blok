import 'package:bela_blok/screens/base_screen.dart';
import 'package:bela_blok/widgets/add_player_dialog.dart';
import 'package:bela_blok/widgets/empty_screen_placeholder.dart';
import 'package:bela_blok/widgets/player_card.dart';
import 'package:flutter/material.dart';

class PlayersScreen extends BaseScreen {
  const PlayersScreen({super.key});

  @override
  String getTitle(BuildContext context) => "Igrači";

  @override
  Widget? getFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showAddPlayerDialog(context),
      child: const Icon(Icons.person_add),
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO: ucitat podatke iz baze podataka i to displayat
    final List<Map<String, dynamic>> players = [];

    if (players.isEmpty) {
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
      );
    }

    //TODO: mozda dodat refresh indicator
    return ListView.builder(
      itemCount: players.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final player = players[index];

        return PlayerCard(
          playerName: player['name'],
          numGamesPlayed: player['games'],
          numWins: player['wins'],
        );
      },
    );
  }
}

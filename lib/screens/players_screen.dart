import 'package:bela_blok/database/database_helper.dart';
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getPlayers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Greška pri učitavanju: ${snapshot.error}"),
          );
        }

        final players = snapshot.data ?? [];

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

        //TODO: mozda dodati refresh indicator
        return ListView.builder(
          itemCount: players.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final player = players[index];

            return PlayerCard(
              playerName: player['name'],
              numGamesPlayed: player['numGamesPlayed'] ?? 0,
              numWins: player['numWins'] ?? 0,
            );
          },
        );
      },
    );
  }
}

import 'package:bela_blok/widgets/player_card.dart';
import 'package:flutter/material.dart';

class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: ucitat podatke iz baze podataka i to displayat
    final List<Map<String, dynamic>> players = [
      {'name': 'Ana', 'games': 12, 'wins': 8},
      {'name': 'Ivan', 'games': 15, 'wins': 5},
      {'name': 'Petra', 'games': 10, 'wins': 7},
      {'name': 'Ana', 'games': 12, 'wins': 8},
      {'name': 'Ivan', 'games': 15, 'wins': 5},
      {'name': 'Petra', 'games': 10, 'wins': 7},
      {'name': 'Ana', 'games': 12, 'wins': 8},
      {'name': 'Ivan', 'games': 15, 'wins': 5},
      {'name': 'Petra', 'games': 10, 'wins': 7},
      {'name': 'Ana', 'games': 12, 'wins': 8},
      {'name': 'Ivan', 'games': 15, 'wins': 5},
      {'name': 'Petra', 'games': 10, 'wins': 7},
      {'name': 'Ana', 'games': 12, 'wins': 8},
      {'name': 'Ivan', 'games': 15, 'wins': 5},
      {'name': 'Petra', 'games': 10, 'wins': 7},
    ];

    //TODO: popravit izgled kad je prazno
    if (players.isEmpty) {
      return const Center(child: Text('Nema spremljenih igrača.'));
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

import 'package:bela_blok/models/round.dart';
import 'package:bela_blok/widgets/round_dialog.dart';
import 'package:bela_blok/widgets/delete_round_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class RoundCard extends StatelessWidget {
  final Round round;
  final void Function() loadRounds;
  final bool gameFinished;

  const RoundCard({
    super.key,
    required this.round,
    required this.loadRounds,
    required this.gameFinished,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: IconButton(
          onPressed: gameFinished
              ? null
              : () => _openEditRoundDialog(context, round),
          color: colorScheme.tertiary,
          icon: Icon(Symbols.edit_rounded, fill: 0),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                round.callingTeam == 1 &&
                        round.team1Points == 0 &&
                        round.stigljaTeam == 0
                    ? "-"
                    : "${round.team1Points}",
                style: textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                round.callingTeam == 2 &&
                        round.team2Points == 0 &&
                        round.stigljaTeam == 0
                    ? "-"
                    : "${round.team2Points}",
                style: textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: gameFinished
              ? null
              : () => _openDeleteRoundDialog(context, round),
          color: colorScheme.error,
          icon: Icon(Symbols.delete_rounded, fill: 0),
        ),
      ),
    );
  }

  void _openEditRoundDialog(BuildContext context, Round round) async {
    final bool? isEdited = await showRoundDialog(
      context,
      round.game,
      round: round,
    );

    if (isEdited == true && context.mounted) {
      loadRounds();
    }
  }

  void _openDeleteRoundDialog(BuildContext context, Round round) async {
    final bool? isDeleted = await showDeleteRoundDialog(context, round);

    if (isDeleted == true && context.mounted) {
      loadRounds();
    }
  }
}

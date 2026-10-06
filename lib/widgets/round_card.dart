import 'package:bela_blok/models/round.dart';
import 'package:bela_blok/widgets/round_dialog.dart';
import 'package:bela_blok/widgets/delete_round_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class RoundCard extends StatelessWidget {
  final Round round;
  final void Function() loadRounds;

  const RoundCard({super.key, required this.round, required this.loadRounds});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: IconButton(
          onPressed: () => _openEditRoundDialog(context, round),
          icon: Icon(
            Symbols.edit_rounded,
            fill: 0,
            color: colorScheme.tertiary,
          ),
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
          onPressed: () => _openDeleteRoundDialog(context, round),
          icon: Icon(Symbols.delete_rounded, fill: 0, color: colorScheme.error),
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

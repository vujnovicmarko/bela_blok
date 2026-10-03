import 'package:bela_blok/models/round.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class RoundCard extends StatelessWidget {
  final Round round;
  final void Function() loadData;

  const RoundCard({super.key, required this.round, required this.loadData});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 8),
        title: Text("${round.team1Points} - ${round.team2Points}"),
        // trailing: IconButton(
        //   onPressed: () => _openDeletePlayerDialog(context, player),
        //   icon: Icon(Symbols.delete_rounded, fill: 0, color: colorScheme.error),
        // ),
      ),
    );
  }

  // void _openDeletePlayerDialog(BuildContext context, Player player) async {
  //   await showDeletePlayerDialog(context, player);
  //   loadData();
  // }
}

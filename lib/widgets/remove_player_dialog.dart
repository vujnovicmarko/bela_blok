import 'package:bela_blok/database/database_helper.dart';
import 'package:flutter/material.dart';

Future<void> showDeletePlayerDialog(
  BuildContext context,
  int id,
  String playerName,
  int numGamesPlayed,
) async {
  await showDialog<void>(
    context: context,
    builder: (context) => DeletePlayerDialog(
      id: id,
      playerName: playerName,
      numGamesPlayed: numGamesPlayed,
    ),
  );
}

class DeletePlayerDialog extends StatefulWidget {
  final int id;
  final String playerName;
  final int numGamesPlayed;

  const DeletePlayerDialog({
    super.key,
    required this.id,
    required this.playerName,
    required this.numGamesPlayed,
  });

  @override
  State<StatefulWidget> createState() => _DeletePlayerDialogState();
}

class _DeletePlayerDialogState extends State<DeletePlayerDialog> {
  bool _isLoading = false;

  Future<void> _deletePlayer() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await DatabaseHelper.instance.deletePlayer(widget.id);

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text("Obriši igrača"),
      content: Text(
        "Jeste li sigurni da želite obrisati igrača ${widget.playerName}? Brisanjem igrača brišu se sve partije u kojima je sudjelovao: ${widget.numGamesPlayed}.",
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text("Odustani"),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
          onPressed: _isLoading ? null : _deletePlayer,
          child: _isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(),
                )
              : const Text("Obriši"),
        ),
      ],
    );
  }
}

import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/player.dart';
import 'package:flutter/material.dart';

Future<bool?> showDeletePlayerDialog(
  BuildContext context,
  Player player,
) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => DeletePlayerDialog(player: player),
  );
}

class DeletePlayerDialog extends StatefulWidget {
  final Player player;

  const DeletePlayerDialog({super.key, required this.player});

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
      await DatabaseHelper.instance.deletePlayer(widget.player);

      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
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
        "Jeste li sigurni da želite obrisati igrača ${widget.player.name}? Brisanjem igrača brišu se sve partije u kojima je sudjelovao: ${widget.player.numGamesPlayed}.",
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text("Odustani"),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
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

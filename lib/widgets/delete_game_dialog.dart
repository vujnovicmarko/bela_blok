import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/game.dart';
import 'package:flutter/material.dart';

Future<bool?> showDeleteGameDialog(BuildContext context, Game game) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => DeleteGameDialog(game: game),
  );
}

class DeleteGameDialog extends StatefulWidget {
  final Game game;

  const DeleteGameDialog({super.key, required this.game});

  @override
  State<StatefulWidget> createState() => _DeleteGameDialogState();
}

class _DeleteGameDialogState extends State<DeleteGameDialog> {
  bool _isLoading = false;

  Future<void> _deleteGame() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await DatabaseHelper.instance.deleteGame(widget.game);

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
      title: const Text("Obriši partiju"),
      content: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: "Jeste li sigurni da želite "),
            TextSpan(
              text: "obrisati ovu partiju",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            const TextSpan(text: "? Brisanjem ove partije "),
            TextSpan(
              text: "mijenjaju",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.tertiary,
              ),
            ),
            const TextSpan(
              text: " se statistike igrača koji su sudjelovali u njoj. Ova akcija je ",
            ),
            TextSpan(
              text: "nepovratna",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            const TextSpan(text: "."),
          ],
        ),
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
          onPressed: _isLoading ? null : _deleteGame,
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

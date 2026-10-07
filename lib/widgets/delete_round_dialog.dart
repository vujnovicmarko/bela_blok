import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/round.dart';
import 'package:flutter/material.dart';

Future<bool?> showDeleteRoundDialog(BuildContext context, Round round) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => DeleteRoundDialog(round: round),
  );
}

class DeleteRoundDialog extends StatefulWidget {
  final Round round;

  const DeleteRoundDialog({super.key, required this.round});

  @override
  State<StatefulWidget> createState() => _DeleteRoundDialogState();
}

class _DeleteRoundDialogState extends State<DeleteRoundDialog> {
  bool _isLoading = false;

  Future<void> _deleteRound() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await DatabaseHelper.instance.deleteRound(widget.round);

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
      title: const Text("Obriši rundu"),
      content: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: "Jeste li sigurni da želite "),
            TextSpan(
              text: "obrisati",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            const TextSpan(text: " ovu rundu? Ova akcija je "),
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
          onPressed: _isLoading ? null : _deleteRound,
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

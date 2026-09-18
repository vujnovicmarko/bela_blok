import 'package:bela_blok/database/database_helper.dart';
import 'package:flutter/material.dart';

Future<bool?> showDeleteAllDataDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => DeleteAllDataDialog(),
  );
}

class DeleteAllDataDialog extends StatefulWidget {
  const DeleteAllDataDialog({super.key});

  @override
  State<StatefulWidget> createState() => _DeleteAllDataDialogState();
}

class _DeleteAllDataDialogState extends State<DeleteAllDataDialog> {
  bool _isLoading = false;

  Future<void> _deleteAllData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await DatabaseHelper.instance.deleteAllData();

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
      title: const Text("Obriši sve podatke"),
      content: Text(
        "Jeste li sigurni da želite obrisati sve podatke? Ova akcija je nepovratna.",
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
          onPressed: _isLoading ? null : _deleteAllData,
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

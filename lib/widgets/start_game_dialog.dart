import 'package:flutter/material.dart';

Future<void> showStartGameDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => const StartGameDialog(),
  );
}

//TODO: treba dodati partiju u bazu podataka
// obaviti sve provjere

class StartGameDialog extends StatelessWidget {
  const StartGameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Započni partiju"),
      // TODO: dodat biranje igraca, vrijednost igre, bez/sa zvanjem
      content: const Text("Opis"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Odustani"),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Započni"),
        ),
      ],
    );
  }
}

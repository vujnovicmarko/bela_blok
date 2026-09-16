import 'package:flutter/material.dart';

Future<void> showAddPlayerDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => const AddPlayerDialog(),
  );
}

//TODO: treba dodati igraca u bazu podataka
// provjeriti je li postoji igrac
// provjeriti je li unos dobar itd.

class AddPlayerDialog extends StatelessWidget {
  const AddPlayerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Dodaj igrača"),
      //TODO: dodat textfield
      content: const Text("Opis"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Odustani"),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Dodaj"),
        ),
      ],
    );
  }
}

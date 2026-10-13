import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/player.dart';
import 'package:flutter/material.dart';

Future<bool?> showAddPlayerDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => const AddPlayerDialog(),
  );
}

class AddPlayerDialog extends StatefulWidget {
  const AddPlayerDialog({super.key});

  @override
  State<StatefulWidget> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _controller.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final exists = await DatabaseHelper.instance.doesPlayerExist(name);

      if (exists) {
        if (!mounted) {
          return;
        }

        setState(() {
          _errorMessage = "Igrač s tim imenom već postoji";
          _isLoading = false;
        });

        return;
      }

      final player = Player(name: name);

      await DatabaseHelper.instance.insertPlayer(player);

      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = "Greška pri spremanju u bazu";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Dodaj igrača"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          enabled: !_isLoading,
          autofocus: true,
          maxLength: 16,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: "Ime igrača",
            errorText: _errorMessage,
            errorMaxLines: 2,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Unesite ime igrača";
            }

            final trimmed = value.trim();

            if (trimmed.length < 2) {
              return "Ime mora imati barem 2 znaka";
            }

            if (trimmed.length > 16) {
              return "Ime može imati najviše 16 znakova";
            }

            return null;
          },
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text("Odustani"),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(),
                )
              : const Text("Dodaj"),
        ),
      ],
    );
  }
}

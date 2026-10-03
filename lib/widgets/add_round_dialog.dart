import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/models/meld.dart';
import 'package:bela_blok/models/round.dart';
import 'package:flutter/material.dart';

Future<bool?> showAddRoundDialog(BuildContext context, Game game) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AddRoundDialog(game: game),
  );
}

class AddRoundDialog extends StatefulWidget {
  final Game game;

  const AddRoundDialog({super.key, required this.game});

  @override
  State<StatefulWidget> createState() => _AddRoundDialogState();
}

class _AddRoundDialogState extends State<AddRoundDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _team1Controller = TextEditingController(
    text: "0",
  );
  final TextEditingController _team2Controller = TextEditingController(
    text: "0",
  );

  int _callingTeam = 1;
  int _stigljaTeam = 0;

  final List<Meld> _team1Melds = [];
  final List<Meld> _team2Melds = [];

  bool _isUpdatingText = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _team1Controller.addListener(_onTeam1Changed);
    _team2Controller.addListener(_onTeam2Changed);
  }

  @override
  void dispose() {
    _team1Controller.dispose();
    _team2Controller.dispose();
    super.dispose();
  }

  void _onTeam1Changed() {
    if (_isUpdatingText || _stigljaTeam != 0) return;
    _isUpdatingText = true;

    final val = int.tryParse(_team1Controller.text.trim());

    if (val != null && val >= 0 && val <= 162) {
      _team2Controller.text = (162 - val).toString();
    }

    _isUpdatingText = false;
  }

  void _onTeam2Changed() {
    if (_isUpdatingText || _stigljaTeam != 0) return;
    _isUpdatingText = true;

    final val = int.tryParse(_team2Controller.text.trim());

    if (val != null && val >= 0 && val <= 162) {
      _team1Controller.text = (162 - val).toString();
    }

    _isUpdatingText = false;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final team1CardPoints = int.parse(_team1Controller.text.trim());
    final team2CardPoints = int.parse(_team2Controller.text.trim());

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final round = Round(
        game: widget.game,
        callingTeam: _callingTeam,
        team1CardPoints: team1CardPoints,
        team2CardPoints: team2CardPoints,
        team1Melds: _team1Melds,
        team2Melds: _team2Melds,
        stigljaTeam: _stigljaTeam,
      );

      await DatabaseHelper.instance.insertRound(round);

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
      title: const Text("Upiši rundu"),
      content: _buildContent(context),
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
              : const Text("Upiši"),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (_errorMessage != null) ...[
            //   Text(
            //     _errorMessage!,
            //     style: const TextStyle(color: Colors.red, fontSize: 13),
            //     textAlign: TextAlign.center,
            //   ),
            //   const SizedBox(height: 8),
            // ],
            _buildCallingTeamField(context),
            const SizedBox(height: 16),
            _buildStigljaTeamField(context),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCardPointsField(
                    context,
                    "MI Bodovi",
                    _team1Controller,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCardPointsField(
                    context,
                    "VI Bodovi",
                    _team2Controller,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            // _buildMeldField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCallingTeamField(BuildContext context) {
    return Column(
      children: [
        const Text("Tko je zvao?"),
        const SizedBox(height: 4),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 1, label: Text("MI")),
            ButtonSegment(value: 2, label: Text("VI")),
          ],
          selected: {_callingTeam},
          onSelectionChanged: (val) {
            setState(() => _callingTeam = val.first);
          },
        ),
      ],
    );
  }

  Widget _buildStigljaTeamField(BuildContext context) {
    return Column(
      children: [
        const Text("Štiglja?"),
        const SizedBox(height: 4),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text("Nema")),
            ButtonSegment(value: 1, label: Text("MI")),
            ButtonSegment(value: 2, label: Text("VI")),
          ],
          selected: {_stigljaTeam},
          onSelectionChanged: (val) {
            setState(() {
              _stigljaTeam = val.first;

              if (_stigljaTeam == 1) {
                _team1Controller.text = "162";
                _team2Controller.text = "0";
              } else if (_stigljaTeam == 2) {
                _team1Controller.text = "0";
                _team2Controller.text = "162";
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildCardPointsField(
    BuildContext context,
    String label,
    TextEditingController controller,
  ) {
    return Column(
      children: [
        Text(label),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          enabled: _stigljaTeam == 0,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          validator: (points) => _validateCardPoints(points),
        ),
      ],
    );
  }

  Widget _buildMeldField(BuildContext context) {
    return Column(
      children: [
        const Text("Zvanja"),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildMeldSection(
                _team1Melds,
                onAddMeld: (meld) => setState(() => _team1Melds.add(meld)),
                onRemoveMeld: (index) =>
                    setState(() => _team1Melds.removeAt(index)),
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: _buildMeldSection(
                _team2Melds,
                onAddMeld: (meld) => setState(() => _team2Melds.add(meld)),
                onRemoveMeld: (index) =>
                    setState(() => _team2Melds.removeAt(index)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMeldSection(
    List<Meld> teamMelds, {
    required Function(Meld) onAddMeld,
    required Function(int) onRemoveMeld,
  }) {
    return Column(
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: Meld.values.map((meld) {
            return ActionChip(
              labelPadding: const EdgeInsets.symmetric(horizontal: 2),
              label: Text(
                "+${meld.value}",
                style: const TextStyle(fontSize: 11),
              ),
              onPressed: () => onAddMeld(meld),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),

        // Lista dodanih zvanja s kantom za smeće
        if (teamMelds.isEmpty)
          const Text(
            "Nema zvanja",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: teamMelds.length,
            itemBuilder: (context, index) {
              final meld = teamMelds[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${meld.value}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    InkWell(
                      onTap: () => onRemoveMeld(index),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  String? _validateCardPoints(String? points) {
    if (points == null || points.trim().isEmpty) {
      return "Unesite broj bodova";
    }

    final parsedPoints = int.tryParse(points.trim());

    if (parsedPoints == null || parsedPoints < 0 || parsedPoints > 162) {
      return "Broj bodova mora biti između 0 i 162";
    }

    return null;
  }
}

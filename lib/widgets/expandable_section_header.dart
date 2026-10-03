import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ExpandableSectionHeader extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final void Function() onTap;

  const ExpandableSectionHeader({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title),
      trailing: Icon(
        isExpanded ? Symbols.expand_less_rounded : Symbols.expand_more_rounded,
        fill: 0,
      ),
      onTap: onTap,
    );
  }
}

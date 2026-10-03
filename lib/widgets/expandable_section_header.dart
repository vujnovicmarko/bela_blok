import 'package:flutter/material.dart';

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
      trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
      onTap: onTap,
    );
  }
}

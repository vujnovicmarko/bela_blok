import 'package:flutter/material.dart';

abstract class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  String getTitle(BuildContext context);

  Widget? getFloatingActionButton(BuildContext context) => null;
}

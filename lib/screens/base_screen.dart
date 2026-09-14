import 'package:flutter/material.dart';

abstract class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  Text getTitle(BuildContext context);

  Widget? getFloatingActionButton(BuildContext context) => null;
}

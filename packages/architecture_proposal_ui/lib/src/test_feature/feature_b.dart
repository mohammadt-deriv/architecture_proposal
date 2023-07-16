import 'package:flutter/material.dart';

class FeatureB extends StatelessWidget {
  const FeatureB({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary)),
        height: 150,
        width: 150,
        child: const Center(child: Text('I am feature B')));
  }
}

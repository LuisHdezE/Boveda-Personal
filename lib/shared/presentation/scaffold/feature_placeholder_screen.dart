import 'package:flutter/material.dart';

class FeaturePlaceholderScreen extends StatelessWidget {
  const FeaturePlaceholderScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Semantics(
          header: true,
          child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        ),
      ),
    );
  }
}

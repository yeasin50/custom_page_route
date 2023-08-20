import 'package:flutter/material.dart';

import 'example1.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstWidget(popData: 'Z'),
    );
  }
}

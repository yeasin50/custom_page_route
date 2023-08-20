import 'package:collection/collection.dart';
import 'package:custom_page_route/custom_page_route.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class FirstWidget extends StatefulWidget {
  ///create a widget on the top of the stack
  const FirstWidget({super.key, this.popData});

  /// used on pop
  final String? popData;

  @override
  State<FirstWidget> createState() => _FirstWidgetState();
}

class _FirstWidgetState extends State<FirstWidget> {
  String? data;

  Offset? tapPosition;

  final math.Random random = math.Random();
  late List<Offset> ripplePositions = [
    for (double i = 0; i < 1; i += .1)
      for (double j = 0; j < 1; j += .1) Offset(i, j)
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    return GestureDetector(
      onPanDown: (v) {
        tapPosition = v.globalPosition;
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: ripplePositions
                .mapIndexed((index, e) => Positioned(
                      left: e.dx * constraints.maxWidth,
                      top: e.dy * constraints.maxHeight,
                      child: buildNavButton(
                        context,
                        index,
                        constraints: constraints,
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  IconButton buildNavButton(BuildContext context, int index, {required BoxConstraints constraints}) {
    final Color color = Colors.primaries[index % Colors.primaries.length];
    return IconButton(
      iconSize: 50,
      color: color,
      onPressed: () async {
        final route = RippleRoute<String?>(
          page: SecondWidget(returnData: widget.popData),
          backgroundColor: color,
          center: constraints.fractionalOffset(tapPosition!),
          popPosition: index.isEven ? FractionalOffset.bottomRight : null,
        );
        await Navigator.push(context, route);
      },
      icon: const Icon(Icons.circle),
    );
  }
}

class SecondWidget extends StatefulWidget {
  const SecondWidget({super.key, required this.returnData});

  final dynamic returnData;
  @override
  SecondWidgetState createState() => SecondWidgetState();
}

class SecondWidgetState extends State<SecondWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context, widget.returnData),
          child: const Text('pop to Origin'),
        ),
      ),
    );
  }
}

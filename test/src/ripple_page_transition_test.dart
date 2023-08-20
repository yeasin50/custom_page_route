import 'package:custom_page_route/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FirstWidget extends StatefulWidget {
  ///create a widget on the top of the stack
  const FirstWidget({super.key, this.popData});

  /// used on pop
  final String? popData;

  @override
  State<FirstWidget> createState() => _FirstWidgetState();
}

class _FirstWidgetState extends State<FirstWidget> {
  dynamic data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (data != null) Text(data.toString()),
        GestureDetector(
          onTap: () async {
            final route = RippleRoute<String?>(
              page: SecondWidget(returnData: widget.popData),
              center: FractionalOffset.bottomCenter,
            );
            final result = await Navigator.push(context, route);
            setState(() {
              data = result;
            });
          },
          child: const ColoredBox(
            color: Color(0xFFFFFF00),
            child: Text('X'),
          ),
        ),
      ],
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
    return GestureDetector(
      onTap: () => Navigator.pop(context, widget.returnData),
      child: const ColoredBox(
        color: Color(0xFFFF00FF),
        child: Text('Y'),
      ),
    );
  }
}

void main() {
  group("RippleRoute", () {
    test('should be PageRouteBuilder', () async {
      //arrange
      final rippleRoute = RippleRoute(page: Container(), center: FractionalOffset.center);
      //act

      //assert
      expect(rippleRoute, isA<PageRouteBuilder>());
    });

    group("widget test", () {
      testWidgets('Can navigator navigate to and from a stateful widget', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: FirstWidget()));
        expect(find.text('X'), findsOneWidget);
        expect(find.text('Y', skipOffstage: false), findsNothing);

        await tester.tap(find.text('X'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('X'), findsOneWidget);
        expect(find.text('Y'), findsOneWidget);
      });
    });

    testWidgets('get pop data', (tester) async {
      //arrange
      const popData = "Z";

      //act
      await tester.pumpWidget(const MaterialApp(home: FirstWidget(popData: popData)));
      await tester.tap(find.text('X'));

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      //assert
      expect(find.text('X', skipOffstage: false), findsOneWidget);
      expect(find.text('Y'), findsOneWidget);
      expect(find.text(popData, skipOffstage: true), findsNothing);

      await tester.tap(find.text('Y'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('X', skipOffstage: false), findsOneWidget);
      expect(find.text('Y'), findsNothing);
      expect(find.text(popData, skipOffstage: false), findsOneWidget);
    });
  });
}

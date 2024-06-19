import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dima_direct_app/main.dart'; // 올바른 MyApp import 경로

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // MyApp을 앱의 루트 위젯으로 사용
    await tester.pumpWidget(const MyApp());

    // Counter가 초기 상태에서 0인지 확인
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // + 아이콘을 눌러서 Counter를 증가
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Counter가 1로 증가했는지 확인
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

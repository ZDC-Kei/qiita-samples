import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:map_app/main.dart';

void main() {
  testWidgets('東京駅の地図画面を表示する', (WidgetTester tester) async {
    await tester.pumpWidget(const MapApp());

    expect(find.text('東京駅の地図'), findsOneWidget);
    expect(find.byType(RichAttributionWidget), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_tracker_flutter/main.dart';

void main() {
  testWidgets('Add Task button opens dialog', (WidgetTester tester) async {
    await tester.pumpWidget(TaskTracker());

    // Verify that the "Add Task" button is present
    expect(find.widgetWithText(ElevatedButton, 'Add Task'), findsOneWidget);

    // Tap the "Add Task" button and trigger a frame
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Task'));
    await tester.pump();

    // Verify that the "Add Task" dialog is opened
    expect(find.text('Add Task'), findsOneWidget);
  });
}

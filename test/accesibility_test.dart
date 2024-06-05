import 'package:flutter_test/flutter_test.dart';
import 'package:two_a/views/login_view.dart';

void main() {
  testWidgets('LoginPage meets androidTapTargetGuideline',
      (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(LoginView());
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    handle.dispose();
  });
}

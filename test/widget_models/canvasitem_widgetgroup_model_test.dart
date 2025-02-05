import 'package:flutter_test/flutter_test.dart';
import 'package:gimelstudio/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('CanvasitemWidgetgroupModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}

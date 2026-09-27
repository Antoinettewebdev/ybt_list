import 'package:flutter_test/flutter_test.dart';
import 'package:ybt_chat/core/constants/app_constants.dart';

void main() {
  test('app name is configured', () {
    expect(AppConstants.appName, 'YBT Chat');
    expect(AppConstants.defaultCurrency, 'GHS');
  });
}

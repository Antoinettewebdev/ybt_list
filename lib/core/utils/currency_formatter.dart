import 'package:intl/intl.dart';

import '../constants/app_constants.dart';
import 'money.dart';

/// Formats amounts in Ghana Cedis (GHS).
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _cedisFormat = NumberFormat.currency(
    locale: AppConstants.defaultLocale,
    symbol: 'GH₵',
    decimalDigits: 2,
  );

  static String formatCedis(double amount) => _cedisFormat.format(amount);

  static String formatMoney(Money money) =>
      formatCedis(money.amountInCedis);

  static String formatPesewas(int pesewas) =>
      formatCedis(pesewas / 100);
}

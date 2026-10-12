import 'cart_provider.dart';

class OrderSummaryProvider {
  final CartProvider cartProvider;

  OrderSummaryProvider(this.cartProvider);

  double get subtotal => cartProvider.subtotalAmount;

  double get tax => subtotal * 0.10; // 10% Tax

  double get deliveryFee => subtotal > 50 || subtotal == 0 ? 0.0 : 5.0;

  double get grandTotal => subtotal + tax + deliveryFee;
}
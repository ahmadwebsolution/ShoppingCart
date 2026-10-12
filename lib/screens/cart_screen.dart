import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_summary_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    // ProxyProvider dependent value
    final summary = context.watch<OrderSummaryProvider>();

    final cartList = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => context.read<CartProvider>().clearCart(),
            ),
        ],
      ),
      body: cartList.isEmpty
          ? const Center(child: Text('Your Cart is empty.'))
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: cartList.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (ctx, i) {
                final item = cartList[i];
                return ListTile(
                  leading: Image.network(
                    item.product.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  title: Text(item.product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    '\$${item.product.price} x ${item.quantity} = \$${item.totalPrice.toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          context.read<CartProvider>().decreaseQuantity(item.product.id);
                        },
                      ),
                      Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          context.read<CartProvider>().addToCart(item.product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<CartProvider>().removeItem(item.product.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:'),
                      Text('\$${summary.subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tax (10%):'),
                      Text('\$${summary.tax.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery:'),
                      Text(summary.deliveryFee == 0 ? 'FREE' : '\$${summary.deliveryFee.toStringAsFixed(2)}'),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Grand Total:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        '\$${summary.grandTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order Placed Successfully!')),
                        );
                        context.read<CartProvider>().clearCart();
                        Navigator.pop(context);
                      },
                      child: const Text('Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
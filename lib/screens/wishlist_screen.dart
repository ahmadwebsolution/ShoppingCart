import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch() is used because wishlist changes when item is un-favorited
    final productProvider = context.watch<ProductProvider>();
    final wishlist = productProvider.wishlist;

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlist.isEmpty
          ? const Center(child: Text('Wishlist is empty!'))
          : ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (ctx, i) {
          final product = wishlist[i];
          return ListTile(
            leading: Image.network(product.image, width: 45, height: 45, fit: BoxFit.contain),
            title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text('\$${product.price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    context.read<CartProvider>().addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.title} added to cart!')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    context.read<ProductProvider>().toggleFavorite(product.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
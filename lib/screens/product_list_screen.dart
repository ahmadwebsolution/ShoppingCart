import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Products'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme(!themeProvider.isDarkMode);
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
          ),
          Consumer<CartProvider>(
            builder: (ctx, cart, child) => Badge(
              label: Text('${cart.itemCount}'),
              isLabelVisible: cart.itemCount > 0,
              alignment: const AlignmentDirectional(20, -2),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProv, child) {
          switch (productProv.status) {
            case ProductStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case ProductStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      productProv.errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<ProductProvider>().loadProducts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );

            case ProductStatus.loaded:
              return RefreshIndicator(
                onRefresh: () => context.read<ProductProvider>().loadProducts(),
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: productProv.products.length,
                  itemBuilder: (ctx, i) {
                    final product = productProv.products[i];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: IconButton(
                                    icon: Icon(
                                      product.isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: product.isFavorite ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () {
                                      context.read<ProductProvider>().toggleFavorite(product.id);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<CartProvider>().addToCart(product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${product.title} added to cart!'),
                                          duration: const Duration(milliseconds: 900),
                                        ),
                                      );
                                    },
                                    child: const Text('Add to Cart'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );

            case ProductStatus.initial:
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
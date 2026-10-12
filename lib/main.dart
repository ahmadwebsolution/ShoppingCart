import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_summary_provider.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // ProxyProvider: Updates OrderSummaryProvider whenever CartProvider changes
        ProxyProvider<CartProvider, OrderSummaryProvider>(
          update: (_, cartProvider, __) => OrderSummaryProvider(cartProvider),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProv, child) {
          return MaterialApp(
            title: 'Shopping App',
            debugShowCheckedModeBanner: false,
            themeMode: themeProv.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: Colors.indigo,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.indigo,
            ),
            home: const ProductListScreen(),
          );
        },
      ),
    );
  }
}
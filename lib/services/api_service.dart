import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Dono alag-alag poore URLs yahan define kar lo:
  static const String productsApiUrl = 'https://fakestoreapi.com/products';
  static const String cartApiUrl = 'https://fakestoreapi.com/carts/1';

  /// 1. Pehli API: Saare Products lane ke liye
  Future<List<Product>> fetchProducts() async {  try {
      final response = await http.get(Uri.parse(productsApiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Products load nahi ho sake: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// 2. Doosri API: Cart data lane ke liye
  Future<Map<String, dynamic>> fetchCart() async {
    try {
      final response = await http.get(Uri.parse(cartApiUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Cart data load nahi ho saka: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
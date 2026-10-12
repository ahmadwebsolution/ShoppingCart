import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  ProductStatus _status = ProductStatus.initial;
  String _errorMessage = '';

  List<Product> get products => _products;
  ProductStatus get status => _status;
  String get errorMessage => _errorMessage;

  List<Product> get wishlist => _products.where((item) => item.isFavorite).toList();

  Future<void> loadProducts() async {
    _status = ProductStatus.loading;
    notifyListeners();

    try {
      _products = await _apiService.fetchProducts();
      _status = ProductStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = ProductStatus.error;
    }
    notifyListeners();
  }

  void toggleFavorite(int productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index].isFavorite = !_products[index].isFavorite;
      notifyListeners();
    }
  }
}
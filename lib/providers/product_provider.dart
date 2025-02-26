// lib/providers/product_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import 'product_state.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Create a StateNotifier to manage the ProductState
class ProductNotifier extends StateNotifier<ProductState> {
  final ApiService _apiService;

  ProductNotifier(this._apiService) : super(ProductState()) {
    // Load products when the notifier is created
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      // Set loading state
      state = state.copyWith(status: ProductStateStatus.loading);

      // Fetch products
      final products = await _apiService.getProducts();

      // Update state with success
      state = state.copyWith(
        status: ProductStateStatus.success,
        //to be changed to products.products
        products: products.products,
      );
    } catch (e) {
      // Update state with error
      state = state.copyWith(
        status: ProductStateStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }
}

// Create the provider
final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProductNotifier(apiService);
});

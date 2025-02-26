// lib/providers/product_state.dart
import '../models/product.dart';

enum ProductStateStatus {
  initial,
  loading,
  success,
  error,
}

class ProductState {
  final ProductStateStatus status;
  final List<Product> products;
  final String? errorMessage;

  ProductState({
    this.status = ProductStateStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStateStatus? status,
    List<Product>? products,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

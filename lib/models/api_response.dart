
import 'city.dart';
import 'product.dart';

class ApiResponse {
  final String merchant;
  final List<Product> products;
  final List<City> cities;

  ApiResponse({
    required this.merchant,
    required this.products,
    required this.cities,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List;
    List<Product> products = productList.map((i) => Product.fromJson(i)).toList();

    var cityList = json['cities'] as List;
    List<City> cities = cityList.map((i) => City.fromJson(i)).toList();

    return ApiResponse(
      merchant: json['Merchant'],
      products: products,
      cities: cities,
    );
  }
}
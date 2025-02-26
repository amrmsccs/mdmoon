// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/image.dart';
import '../models/product.dart';
import '../models/api_response.dart'; // Import the ApiResponse model

class ApiService {
  late final Dio _dio;
  final String _baseUrl = 'https://mdmooon.com';

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // Add CORS headers
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token',
        },
      ),
    );

    // Add logging interceptor for debugging
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  Future<ApiResponse> getProducts() async {
    try {
      final response = await _dio.get(
        '/user/merchants/',
        queryParameters: {'merchant': 'esam'},
      );

      if (response.statusCode == 200) {
        // Print the entire response for debugging
        if (kDebugMode) {
          print("Full Response: ${response.data}");
        }

        // Parse the entire API response
        return ApiResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Dio Error: ${e.message}');
        print('Response: ${e.response}');
      }
      throw Exception('Error: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('General Error: $e');
      }
      throw Exception('Error: $e');
    }
  }

  // Mock data method for testing
  Future<List<Product>> getMockProducts() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      Product(
        id: 1,
        name: 'Product 1',
        description: 'Description 1',
        price: 99.99,
        //list of images using placeholder api
        images: [
          Image(url: 'https://via.assets.so/watch.png?id=1&q=95&w=360&h=360&fit=fill', isPrimary: true),
          Image(url: 'https://via.assets.so/watch.png?id=3&q=95&w=360&h=360&fit=fill', isPrimary: false),
          Image(url: 'https://via.assets.so/watch.png?id=2&q=95&w=360&h=360&fit=fill', isPrimary: false),
        ],
      ),
      Product(
        id: 2,
        name: 'Product 2',
        description: 'Description 2',
        price: 149.99,
        //list of images using placeholder api
        images: [
          Image(url: 'https://via.assets.so/watch.png?id=4&q=95&w=360&h=360&fit=fill', isPrimary: true),
          Image(url: 'https://via.assets.so/watch.png?id=6&q=95&w=360&h=360&fit=fill', isPrimary: false),
          Image(url: 'https://via.assets.so/watch.png?id=7&q=95&w=360&h=360&fit=fill', isPrimary: false),
        ],
      ),
      // Add more mock products as needed
    ];
  }
}

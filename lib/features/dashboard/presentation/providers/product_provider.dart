import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../data/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final Dio _dio = DioClient.instance;

  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    
    notifyListeners(); 

    try {
      final response = await _dio.get(ApiConstants.products);
      
      final List<dynamic> data = response.data['data'] ?? [];
      
      _products = data.map((json) => ProductModel.fromJson(json)).toList();
      
    } on DioException catch (e) {
      _errorMessage = 'Gagal memuat produk: ${e.response?.statusCode} - ${e.message}';
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem: $e';
    } finally {
      _isLoading = false;
    
      notifyListeners(); 
    }
  }
}
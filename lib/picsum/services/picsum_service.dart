import 'package:dio/dio.dart';
import '../../model/pic_model.dart';

class PicsumService {
  final Dio _dio;
  static const String _baseUrl = 'https://picsum.photos/v2';

  PicsumService() : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 5000);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<List<PicModel>> getPictures({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/list', queryParameters: {'page': page, 'limit': limit});

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => PicModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (_) {
      throw Exception('Failed to load data');
    }
  }
}

import 'package:dio/dio.dart';
import '../../model/hogwarts_character_model.dart';
import '../../model/spell_model.dart';

class HogwartsService {
  final Dio _dio;
  static const String _baseUrl = 'https://hp-api.onrender.com/api';

  HogwartsService() : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 10000);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<List<HogwartsCharacterModel>> getAllCharacters() async {
    try {
      final response = await _dio.get('/characters');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => HogwartsCharacterModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load characters: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }

  Future<List<HogwartsCharacterModel>> getHogwartsStudents() async {
    try {
      final response = await _dio.get('/characters/students');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => HogwartsCharacterModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load students: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load students: $e');
    }
  }

  Future<List<HogwartsCharacterModel>> getHogwartsStaff() async {
    try {
      final response = await _dio.get('/characters/staff');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => HogwartsCharacterModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load staff: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load staff: $e');
    }
  }

  Future<List<SpellModel>> getAllSpells() async {
    try {
      final response = await _dio.get('/spells');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SpellModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load spells: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load spells: $e');
    }
  }

  Future<HogwartsCharacterModel> getCharacterById(String id) async {
    try {
      final response = await _dio.get('/character/$id');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          return HogwartsCharacterModel.fromJson(data.first);
        } else {
          throw Exception('Character not found');
        }
      } else {
        throw Exception('Failed to load character: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load character: $e');
    }
  }
}

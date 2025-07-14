import 'package:astronacci_fe/app/data/models/user_model.dart';
import 'package:astronacci_fe/app/data/services/base_api_services.dart';

class UserServices {
  final BaseApiService _apiService = BaseApiService();

  /// Raw JSON response
  Future<Map<String, dynamic>> getAllUserRaw() async {
    final response = await _apiService.get('/api/auth/users');
    return response.data;
  }

  /// List of UserModel
  Future<List<UserModel>> getAllUsers() async {
    final response = await _apiService.get('/api/auth/users');

    final usersJson = response.data['users'] as List<dynamic>;

    final users = usersJson.map((json) => UserModel.fromJson(json)).toList();

    return users;
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ssl_monitor/utils/requests.dart';

class AuthController extends GetxController {
  final _username = ''.obs;
  final _password = ''.obs;

  late String apiUrl;
  late String apiKey;

  String get username => _username.value;
  String get password => _password.value;

  @override
  void onInit() async {
    apiUrl = dotenv.env['API_URL']!;
    apiKey = dotenv.env['API_KEY']!;

    super.onInit();
  }

  void setUsername(String input) {
    _username.value = input;
  }

  void setPassword(String input) {
    _password.value = input;
  }

  Future<void> auth() async {
    if (_username.isNotEmpty && _password.isNotEmpty) {
      Map<String, dynamic> data = {
        'username': _username.value,
        'password': _password.value,
        'apiKey': apiKey
      };

      final response = await authUser(url: '$apiUrl/user/config/', data: data);

      print(response);
    }
  }
}

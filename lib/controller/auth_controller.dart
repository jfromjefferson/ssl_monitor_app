import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ssl_monitor/database/model/settings/query.dart';
import 'package:ssl_monitor/database/model/settings/settings.dart';
import 'package:ssl_monitor/database/model/user/query.dart';
import 'package:ssl_monitor/database/model/user/user.dart';
import 'package:ssl_monitor/screen/main_screen.dart';
import 'package:ssl_monitor/utils/functions.dart';
import 'package:ssl_monitor/utils/requests.dart';
import 'package:ssl_monitor/utils/utils.dart';

class AuthController extends GetxController {
  final RxString _firstName = ''.obs;
  final RxString _lastName = ''.obs;
  final RxString _username = ''.obs;
  final RxString _password = ''.obs;
  final RxString _repeatPassword = ''.obs;
  final RxBool _isPasswordObscured = true.obs;
  final RxBool _isRepeatPasswordObscured = true.obs;
  final RxBool _isCreateAccountButtonEnabled = false.obs;
  final RxString _selectedLanguage = 'English'.obs;

  String get fistName => _firstName.value;
  String get lastName => _lastName.value;
  String get username => _username.value;
  String get password => _password.value;
  String get repeatPassword => _repeatPassword.value;
  String get selectedLanguage => _selectedLanguage.value;
  bool get isPasswordObscured => _isPasswordObscured.value;
  bool get isRepeatPasswordObscured => _isRepeatPasswordObscured.value;
  bool get isCreateAccountButtonEnabled => _isCreateAccountButtonEnabled.value;

  late String apiUrl;
  late String apiKey;

  Settings? settings;

  @override
  void onInit() async {
    apiUrl = dotenv.env['API_URL']!;
    apiKey = dotenv.env['API_KEY']!;

    settings = await getSettings();

    if (settings == null) {
      Settings settingsTemp = Settings(languageCode: 'en_US');
      await createDBSettings(settings: settingsTemp);
      settings = settingsTemp;
    }

    super.onInit();
  }

  void setFirstName(String input) {
    _firstName.value = input;

    toggleCreateAccountButtonEnabled();
  }

  void setLastName(String input) {
    _lastName.value = input;

    toggleCreateAccountButtonEnabled();
  }

  void setUsername(String input) {
    _username.value = input;

    toggleCreateAccountButtonEnabled();
  }

  void setPassword(String input) {
    _password.value = input;

    toggleCreateAccountButtonEnabled();
  }

  void setRepeatPassword(String input) {
    _repeatPassword.value = input;

    toggleCreateAccountButtonEnabled();
  }

  void togglePasswordVisibility() {
    _isPasswordObscured.value = !_isPasswordObscured.value;

    toggleCreateAccountButtonEnabled();
  }

  void toggleRepeatPasswordVisibility() {
    _isRepeatPasswordObscured.value = !_isRepeatPasswordObscured.value;

    toggleCreateAccountButtonEnabled();
  }

  void toggleCreateAccountButtonEnabled() {
    if (fistName.isNotEmpty &&
        lastName.isNotEmpty &&
        username.isNotEmpty &&
        password.isNotEmpty &&
        repeatPassword.isNotEmpty &&
        password == repeatPassword) {
      _isCreateAccountButtonEnabled.value = true;
    } else {
      _isCreateAccountButtonEnabled.value = false;
    }
  }

  void setSelectedLanguage(String? input) async {
    if (input != null) {
      _selectedLanguage.value = input;

      String languageCode = input == 'English' ? 'en_US' : 'pt_BR';

      if (settings != null) {
        settings!.languageCode = languageCode;
        settings!.save();
      }

      Locale locale = Locale(languageCode);
      Get.updateLocale(locale);
    }
  }

  Future<void> auth() async {
    Get.focusScope!.unfocus();

    if (username.isNotEmpty && password.isNotEmpty) {
      Map<String, dynamic> data = {
        'username': username.toLowerCase(),
        'password': password,
        'apiKey': apiKey
      };

      Get.dialog(
        const Center(child: CircularProgressIndicator(color: purple)),
        barrierDismissible: false,
      );

      final result = await authUser(url: '$apiUrl/user/config/', data: data);

      Get.back();

      bool success = result['success'];

      if (success) {
        Map<String, dynamic> response = result['response'];
        User user = User(
          name: response['user_full_name'],
          sysUserUuid: response['sys_user_uuid'],
          extraInfo: response['extra_info'],
        );

        await createDBUser(user: user);
        Get.delete<AuthController>();

        Get.offAll(() => MainScreen());
      } else {
        print(result);
        result['response'].remove('status_code');
        result['response'].forEach((key, value) {
          showSnackbar(
            success: success,
            title: key,
            message: value,
          );
        });
      }
    }
  }

  Future<void> create() async {
    Get.focusScope!.unfocus();

    if (isCreateAccountButtonEnabled) {
      Map<String, dynamic> data = {
        'first_name': fistName,
        'last_name': lastName,
        'username': username,
        'password': password,
        'apiKey': apiKey,
      };

      Get.dialog(
        const Center(child: CircularProgressIndicator(color: purple)),
        barrierDismissible: false,
      );

      final result = await createUser(url: '$apiUrl/user/config/', data: data);

      Get.back();

      bool success = result['success'];

      if (success) {
        showSnackbar(
          success: success,
          title: 'Success!',
          message: result['response']['message'],
        );

        Get.delete<AuthController>();

        Get.offAll(() => MainScreen());
      } else {
        result['response'].remove('status_code');
        result['response'].forEach((key, value) {
          showSnackbar(
            success: success,
            title: key,
            message: value,
          );
        });
      }
    }
  }
}

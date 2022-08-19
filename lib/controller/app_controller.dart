import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ssl_monitor/database/model/service/query.dart';
import 'package:ssl_monitor/database/model/service/service.dart';
import 'package:ssl_monitor/database/model/user/query.dart';
import 'package:ssl_monitor/database/model/user/user.dart';
import 'package:ssl_monitor/utils/functions.dart';
import 'package:ssl_monitor/utils/requests.dart';

class AppController extends GetxController {
  late User user;
  final RxString _userName = ''.obs;
  final RxString _serviceName = ''.obs;
  final RxString _serviceUrl = ''.obs;
  final RxBool _isEnabled = true.obs;
  final RxBool _isNotify = true.obs;
  final RxBool _isCreateServiceButtonEnabled = false.obs;
  final RxList _serviceList = [].obs;

  String get userName => _userName.value;
  String get serviceName => _serviceName.value;
  String get serviceUrl => _serviceUrl.value;
  bool get isEnabled => _isEnabled.value;
  bool get isNotify => _isNotify.value;
  bool get isCreateServiceButtonEnabled => _isCreateServiceButtonEnabled.value;
  List get serviceList => _serviceList;

  late String apiUrl;
  late String apiKey;

  @override
  void onInit() async {
    apiUrl = dotenv.env['API_URL']!;
    apiKey = dotenv.env['API_KEY']!;

    user = (await getUser())!;
    _serviceList.value = await getServiceList();
    _userName.value = user.name;

    super.onInit();
  }

  void toggleCreateServiceButton() {
    if (serviceName.isNotEmpty && serviceUrl.isNotEmpty) {
      _isCreateServiceButtonEnabled.value = true;
    } else {
      _isCreateServiceButtonEnabled.value = false;
    }
  }

  void resetData() {
    toggleCreateServiceButton();
    _serviceName.value = '';
    _serviceUrl.value = '';
    _isEnabled.value = true;
    _isNotify.value = true;
  }

  void setServiceName(String name) {
    _serviceName.value = name;

    toggleCreateServiceButton();
  }

  void setServiceUrl(String url) {
    _serviceUrl.value = url;

    toggleCreateServiceButton();
  }

  void setIsEnabled(bool isEnabled) {
    _isEnabled.value = isEnabled;

    // toggleCreateServiceButton();
  }

  void setIsNotify(bool isNotify) {
    _isNotify.value = isNotify;

    // toggleCreateServiceButton();
  }

  void createService() async {
    Get.focusScope!.unfocus();

    if (isCreateServiceButtonEnabled) {
      Service service = Service(
        name: serviceName,
        url: serviceUrl,
        user: user,
        enabled: isEnabled,
        notify: isNotify,
        uuid: '',
        serviceInfo: {},
      );

      if (!serviceUrl.contains('https')) {
        setServiceUrl('https://$serviceUrl');
      }

      Map<String, dynamic> data = {
        'apiKey': apiKey,
        'SysUserUuid': user.sysUserUuid,
        'name': serviceName,
        'url': serviceUrl.toLowerCase(),
        'enabled': isEnabled,
        'notify': isNotify,
      };

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await postData(
        url: '$apiUrl/service/config/',
        data: data,
      );

      Get.back(closeOverlays: true);

      bool success = result['success'];

      if (success) {
        String message = result['message'];

        Map<String, dynamic> serviceInfo = result['service_info'];

        service.serviceInfo = serviceInfo;
        service.uuid = serviceInfo['uuid'];

        createDBService(service: service);
        _serviceList.add(service);

        Get.back(closeOverlays: true);

        showSnackbar(success: success, title: 'Success', message: message);
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

  void updateService({required Service service}) async {
    Get.focusScope!.unfocus();

    Requests requests = Requests();

    Map<String, dynamic> data = {
      'name': serviceName,
      'enabled': isEnabled,
      'send_notification': isNotify,
    };

    Map<String, dynamic> headers = {
      'Api-key': apiKey,
      'Sys-user-uuid': service.user.sysUserUuid,
      'Service-uuid': service.uuid,
    };

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final result = await requests.put(
      url: '$apiUrl/service/config/',
      data: data,
      headers: headers,
    );

    Get.back(closeOverlays: true);

    bool success = result['success'];

    if (success) {
      service.name = serviceName;
      service.enabled = isEnabled;
      service.notify = isNotify;
      service.save();

      _serviceList.value = await getServiceList();

      showSnackbar(
        success: success,
        title: 'Success',
        message: result['message'],
      );
    } else {
      result['response_error'].remove('status_code');
      result['response_error'].forEach((key, value) {
        showSnackbar(
          success: success,
          title: key,
          message: value,
        );
      });
    }
  }

  void deleteService({required Service service}) async {
    Requests requests = Requests();

    Map<String, dynamic> headers = {
      'Api-key': apiKey,
      'Sys-user-uuid': service.user.sysUserUuid,
      'Service-uuid': service.uuid,
    };

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final result = await requests.delete(
      url: '$apiUrl/service/config/',
      headers: headers,
    );

    Get.back(closeOverlays: true);

    bool success = result['success'];

    if (success) {
      showSnackbar(
        success: success,
        title: 'Success',
        message: result['message'],
      );
      service.delete();
      _serviceList.value = await getServiceList();
    } else {
      result['response_error'].remove('status_code');
      result['response_error'].forEach((key, value) {
        showSnackbar(
          success: success,
          title: key,
          message: value,
        );
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ssl_monitor/controller/app_controller.dart';
import 'package:ssl_monitor/custom_widget/custom_button.dart';
import 'package:ssl_monitor/custom_widget/custom_text.dart';
import 'package:ssl_monitor/custom_widget/custom_text_field.dart';
import 'package:ssl_monitor/database/model/service/query.dart';
import 'package:ssl_monitor/database/model/service/service.dart';
import 'package:ssl_monitor/database/model/settings/settings.dart';
import 'package:ssl_monitor/database/model/user/user.dart';
import 'package:ssl_monitor/screen/main_screen.dart';
import 'package:ssl_monitor/utils/local_notification.dart';
import 'package:ssl_monitor/utils/utils.dart';

void showSnackbar({
  required bool success,
  required String title,
  required String message,
}) {
  Get.snackbar(
    title.capitalizeFirst!,
    message,
    backgroundColor: success ? Colors.green : Colors.red,
    colorText: Colors.white,
    margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
  );
}

void registerAdapters() {
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(SettingsAdapter());
}

String formatCertExpiryDate({
  required Service service,
  required String certValid,
}) {
  Map<String, dynamic> serviceInfo = service.serviceInfo;
  String date = '';

  if (certValid == 'from') {
    date = serviceInfo['ssl_properties']['cert_valid_from'];
  } else {
    date = serviceInfo['ssl_properties']['cert_valid_until'];
  }

  DateTime strToDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(date);
  String dateFormatted = DateFormat('date_format'.tr).format(strToDateTime);

  return dateFormatted;
}

List<DateTime> getDaysInBetween({required DateTime certValidUntil}) {
  List<DateTime> days = [];

  for (int i = 0; i <= 10; i++) {
    days.add(
      DateTime(
        certValidUntil.year,
        certValidUntil.month,
        certValidUntil.day - i,
        // To set notification to 08:00 AM (America/Sao_Paulo) subtract 3 from final hour. Ex:. 8 - 3 = 5
        5,
      ),
    );
  }

  return days;
}

void selectNotification(String? payload) async {
  if (payload != null) {
    Service service = await getOneService(uuid: payload);

    Get.dialog(
      AlertDialog(
        title: const CustomText(text: 'Cancel notification'),
        content: CustomText(
          text:
              'Are you sure you want to cancel all notifications for ${service.name}?',
        ),
        actions: [
          CustomButton(
            onPressed: () {
              service.notify = false;

              LocalNotificationService.cancelNotification(id: service.key);

              Get.delete<AppController>();
              Get.offAll(() => MainScreen());
            },
            text: 'Yes',
            buttonColor: Colors.red,
            padding: const EdgeInsets.all(5),
          ),
          CustomButton(
            onPressed: () {
              Get.back();
            },
            text: 'No',
            buttonColor: purple,
            padding: const EdgeInsets.all(5),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  } else {
    Get.snackbar('Error', 'Notification not found');
  }
}

void showServiceConfigDialog({
  required AppController appController,
  Service? service,
}) {
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController serviceUrlController = TextEditingController();

  if (service != null) {
    serviceNameController.text = service.name;
    serviceUrlController.text = service.url;

    appController.setServiceName(service.name);
    appController.setServiceUrl(service.url);
    appController.setIsEnabled(service.enabled);
    appController.setIsNotify(service.notify);
  }

  Get.dialog(
    GestureDetector(
      onTap: () {
        Get.focusScope!.unfocus();
      },
      child: AlertDialog(
        title: CustomText(
          text: service == null
              ? 'create_service_title'.tr
              : 'update_service_title'.tr,
          size: 20,
          weight: FontWeight.bold,
          align: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: serviceNameController,
                onChanged: appController.setServiceName,
                hintText: 'service_name_text_field'.tr,
                fillColor: purple,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: serviceUrlController,
                onChanged: appController.setServiceUrl,
                hintText: 'Url',
                fillColor: service == null ? purple : purple.withAlpha(950),
                textCapitalization: TextCapitalization.none,
                enableSuggestions: false,
                autoCorrect: false,
                readOnly: service == null ? false : true,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CustomText(text: 'service_enabled_text'.tr),
                      Obx(
                        () => Switch(
                          onChanged: appController.setIsEnabled,
                          value: appController.isEnabled,
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CustomText(text: 'service_notify_text'.tr),
                      Obx(
                        () => Switch(
                          onChanged: appController.setIsNotify,
                          value: appController.isNotify,
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              service == null
                  ? Obx(
                      () => CustomButton(
                        onPressed: appController.isCreateServiceButtonEnabled
                            ? appController.createService
                            : null,
                        text: 'save'.tr,
                        buttonColor: purple,
                        padding: const EdgeInsets.all(10),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomButton(
                          onPressed: appController.isCreateServiceButtonEnabled
                              ? () =>
                                  appController.updateService(service: service)
                              : null,
                          text: 'update'.tr,
                          buttonColor: purple,
                          padding: const EdgeInsets.all(10),
                        ),
                        const SizedBox(height: 5),
                        CustomButton(
                          onPressed: () {
                            Get.back();
                            appController.deleteService(service: service);
                          },
                          text: 'delete'.tr,
                          buttonColor: Colors.orange,
                          padding: const EdgeInsets.all(10),
                        ),
                      ],
                    ),
              const SizedBox(height: 5),
              CustomButton(
                onPressed: () {
                  appController.resetData();
                  Get.back(closeOverlays: true);
                },
                text: 'cancel'.tr,
                buttonColor: Colors.red,
                padding: const EdgeInsets.all(10),
              ),
            ],
          ),
        ],
      ),
    ),
    barrierDismissible: false,
  );
}

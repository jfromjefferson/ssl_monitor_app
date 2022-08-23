import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ssl_monitor/controller/app_controller.dart';
import 'package:ssl_monitor/custom_widget/custom_button.dart';
import 'package:ssl_monitor/custom_widget/custom_text.dart';
import 'package:ssl_monitor/database/model/service/query.dart';
import 'package:ssl_monitor/database/model/user/query.dart';
import 'package:ssl_monitor/screen/auth_screen.dart';
import 'package:ssl_monitor/utils/functions.dart';
import 'package:ssl_monitor/utils/local_notification.dart';
import 'package:ssl_monitor/utils/utils.dart';

class MainScreen extends StatelessWidget {
  final AppController appController = Get.put(AppController());
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.dialog(
              Obx(
                () => AlertDialog(
                  title: CustomText(text: 'settings'.tr),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomText(text: 'select_language'.tr),
                        const SizedBox(height: 10),
                        DropdownSearch<String>(
                          onChanged: appController.setSelectedLanguage,
                          items: const ['English', 'Português'],
                          selectedItem: appController.selectedLanguage,
                          popupProps: const PopupProps.dialog(
                            constraints: BoxConstraints(maxHeight: 130),
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    CustomButton(
                      onPressed: () {
                        Get.back();
                      },
                      text: 'close'.tr,
                      buttonColor: Colors.red,
                      padding: const EdgeInsets.all(5),
                    )
                  ],
                ),
              ),
            );
          },
          icon: const Icon(LineIcons.cog),
        ),
        title: Center(
          child: Obx(
            () => CustomText(
              text: '${'hi'.tr}, ${appController.userName}',
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: CustomText(text: 'exit_title'.tr),
                  content: CustomText(text: 'exit_text'.tr),
                  actions: [
                    CustomButton(
                      onPressed: () async {
                        await clearService();
                        await clearUser();
                        await LocalNotificationService.cancelAllNotifications();

                        Get.delete<AppController>();

                        Get.offAll(() => AuthScreen());
                      },
                      text: 'yes'.tr,
                      buttonColor: Colors.red,
                      padding: const EdgeInsets.all(5),
                    ),
                    CustomButton(
                      onPressed: () {
                        Get.back();
                      },
                      text: 'no'.tr,
                      buttonColor: purple,
                      padding: const EdgeInsets.all(5),
                    ),
                  ],
                ),
                barrierDismissible: false,
              );
            },
            icon: const Icon(LineIcons.alternateSignOut),
          ),
        ],
      ),
      body: Obx(
        () => Container(
          padding: const EdgeInsets.only(left: 5, top: 10, right: 5),
          child: appController.serviceList.isNotEmpty
              ? ListView.separated(
                  itemCount: appController.serviceList.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Get.back(closeOverlays: true);
                        showServiceConfigDialog(
                          appController: appController,
                          service: appController.serviceList[index],
                        );
                      },
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          leading: const Icon(
                            LineIcons.globe,
                            size: 40,
                          ),
                          title: CustomText(
                            text: appController.serviceList[index].name,
                          ),
                          subtitle: CustomText(
                            text:
                                '${'cert_valid_until_text'.tr} ${formatCertExpiryDate(service: appController.serviceList[index], certValid: 'until')}',
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: CustomText(
                    text: 'empty_list'.tr,
                    size: 23,
                    weight: FontWeight.bold,
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appController.resetData();
          Get.back(closeOverlays: true);

          showServiceConfigDialog(appController: appController);
        },
        child: const Icon(LineIcons.plus),
      ),
    );
  }
}

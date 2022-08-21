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
        leading: const SizedBox(),
        title: Center(
          child: Obx(
            () => CustomText(
              text: 'Hi, ${appController.userName}',
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const CustomText(text: 'Exit'),
                  content:
                      const CustomText(text: 'Are you sure you want to exit?'),
                  actions: [
                    CustomButton(
                      onPressed: () async {
                        await clearService();
                        await clearUser();
                        await LocalNotificationService.cancelAllNotifications();

                        Get.delete<AppController>();

                        Get.offAll(() => AuthScreen());
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
                                'Valid until ${formatCertExpiryDate(service: appController.serviceList[index], certValid: 'until')}',
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: CustomText(
                    text: 'Nothing to show :(',
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

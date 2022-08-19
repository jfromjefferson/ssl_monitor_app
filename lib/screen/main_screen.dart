import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ssl_monitor/controller/app_controller.dart';
import 'package:ssl_monitor/custom_widget/custom_text.dart';
import 'package:ssl_monitor/utils/functions.dart';
import 'package:ssl_monitor/utils/local_notification.dart';

class MainScreen extends StatelessWidget {
  final AppController appController = Get.put(AppController());
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Obx(
            () => CustomText(
              text: 'Hi, ${appController.userName}',
            ),
          ),
        ),
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
                      onTap: () async {
                        await LocalNotificationService.schedule(
                          service: appController.serviceList[index],
                        );
                        // Get.back(closeOverlays: true);
                        // showServiceConfigDialog(
                        //   appController: appController,
                        //   service: appController.serviceList[index],
                        // );
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

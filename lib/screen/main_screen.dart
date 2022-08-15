import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ssl_monitor/controller/app_controller.dart';
import 'package:ssl_monitor/custom_widget/custom_button.dart';
import 'package:ssl_monitor/custom_widget/custom_text.dart';
import 'package:ssl_monitor/custom_widget/custom_text_field.dart';
import 'package:ssl_monitor/utils/utils.dart';

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
      body: Container(
        padding: const EdgeInsets.only(left: 5, top: 10, right: 5),
        child: appController.serviceList.isNotEmpty
            ? Obx(
                () => ListView.separated(
                  itemCount: appController.serviceList.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {},
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
                          subtitle: const CustomText(
                            text: 'Valid until 2022-09-13: 13:25',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Center(
                child: CustomText(
                  text: 'Nothing to show :(',
                  size: 23,
                  weight: FontWeight.bold,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appController.resetData();

          Get.dialog(
            GestureDetector(
              onTap: () {
                Get.focusScope!.unfocus();
              },
              child: AlertDialog(
                title: const CustomText(
                  text: 'New service',
                  size: 20,
                  weight: FontWeight.bold,
                  align: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        onChanged: appController.setServiceName,
                        hintText: 'Name',
                        fillColor: purple,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        onChanged: appController.setServiceUrl,
                        hintText: 'Url',
                        fillColor: purple,
                        textCapitalization: TextCapitalization.none,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const CustomText(text: 'Enabled'),
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
                              const CustomText(text: 'Notify'),
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
                  Obx(
                    () => CustomButton(
                      onPressed: appController.isCreateServiceButtonEnabled
                          ? appController.createService
                          : null,
                      text: 'Save',
                      buttonColor: appController.isCreateServiceButtonEnabled
                          ? purple
                          : purple.withAlpha(950),
                      padding: const EdgeInsets.all(5),
                    ),
                  ),
                  CustomButton(
                    onPressed: () {
                      appController.resetData();
                      Get.back();
                    },
                    text: 'Cancel',
                    buttonColor: Colors.red,
                    padding: const EdgeInsets.all(5),
                  ),
                ],
              ),
            ),
            barrierDismissible: false,
          );
        },
        child: const Icon(LineIcons.plus),
      ),
    );
  }
}

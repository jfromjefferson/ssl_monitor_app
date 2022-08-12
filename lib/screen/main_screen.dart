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
          child: CustomText(
            text: 'Hi, ${appController.userName.toString()}',
          ),
        ),
        backgroundColor: purple,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 5, top: 10, right: 5),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {},
              child: const Card(
                elevation: 2,
                child: ListTile(
                  leading: Icon(
                    LineIcons.globe,
                    size: 40,
                  ),
                  title: CustomText(text: 'Hotel Polaris'),
                  subtitle: CustomText(text: 'Valid until 2022-09-13: 13:25'),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
                        onChanged: (String value) {},
                        hintText: 'Name',
                        fillColor: purple,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        onChanged: (String value) {},
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
                              Switch(
                                onChanged: (bool value) {},
                                value: false,
                                activeColor: Colors.green,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              const CustomText(text: 'Notify'),
                              Switch(
                                onChanged: (bool value) {},
                                value: true,
                                activeColor: Colors.green,
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  CustomButton(
                    onPressed: () {
                      Get.back();
                    },
                    text: 'Save',
                    buttonColor: purple,
                    padding: const EdgeInsets.all(5),
                  ),
                  CustomButton(
                    onPressed: () {
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
        backgroundColor: purple,
        child: const Icon(LineIcons.plus),
      ),
    );
  }
}

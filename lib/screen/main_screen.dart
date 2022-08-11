import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssl_monitor/controller/app_controller.dart';
import 'package:ssl_monitor/custom_widget/custom_text.dart';
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
            text: 'Olá, ${appController.userName.toString()}',
          ),
        ),
        backgroundColor: purple,
      ),
      body: Container(),
    );
  }
}

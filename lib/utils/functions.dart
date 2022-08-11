import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ssl_monitor/database/model/service/service.dart';
import 'package:ssl_monitor/database/model/user/user.dart';

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
}

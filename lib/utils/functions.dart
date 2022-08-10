import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

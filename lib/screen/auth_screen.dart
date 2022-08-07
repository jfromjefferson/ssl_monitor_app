import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ssl_monitor/controller/auth_controller.dart';
import 'package:ssl_monitor/custom_widget/custom_button.dart';
import 'package:ssl_monitor/custom_widget/custom_text_field.dart';
import 'package:ssl_monitor/utils/utils.dart';

class AuthScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.focusScope!.unfocus();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 70,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      onChanged: authController.setUsername,
                      hintText: 'Username',
                      fillColor: purple,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      onChanged: authController.setPassword,
                      suffixIcon: LineIcons.eye,
                      onPressed: () {},
                      hintText: 'Password',
                      fillColor: purple,
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    Obx(() => CustomButton(
                          onPressed: authController.username.isNotEmpty &&
                                  authController.password.isNotEmpty
                              ? authController.auth
                              : () {},
                          text: 'Login',
                          buttonColor: authController.username.isNotEmpty &&
                                  authController.password.isNotEmpty
                              ? purple
                              : purple.withAlpha(950),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

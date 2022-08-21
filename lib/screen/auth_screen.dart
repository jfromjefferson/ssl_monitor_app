import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ssl_monitor/controller/auth_controller.dart';
import 'package:ssl_monitor/custom_widget/custom_button.dart';
import 'package:ssl_monitor/custom_widget/custom_text.dart';
import 'package:ssl_monitor/custom_widget/custom_text_field.dart';
import 'package:ssl_monitor/screen/create_account_screen.dart';
import 'package:ssl_monitor/utils/utils.dart';

class AuthScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.focusScope!.unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 70,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        onChanged: authController.setUsername,
                        hintText: 'Username',
                        fillColor: purple,
                        textCapitalization: TextCapitalization.none,
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => CustomTextField(
                          onChanged: authController.setPassword,
                          suffixIcon: authController.isPasswordObscured
                              ? LineIcons.eye
                              : LineIcons.eyeSlash,
                          onPressed: authController.togglePasswordVisibility,
                          hintText: 'Password',
                          fillColor: purple,
                          obscureText: authController.isPasswordObscured,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => CustomButton(
                          onPressed: authController.username.isNotEmpty &&
                                  authController.password.isNotEmpty
                              ? authController.auth
                              : () {},
                          text: 'Login',
                          buttonColor: authController.username.isNotEmpty &&
                                  authController.password.isNotEmpty
                              ? purple
                              : purple.withAlpha(950),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Get.focusScope!.unfocus();
                      Get.to(
                        () => const CreateAccountScreen(),
                        transition: Transition.cupertino,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomText(
                        text: 'Don\'t have an account?',
                        size: 22,
                        weight: FontWeight.bold,
                        color: purple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownSearch<String>(
                    onChanged: (String? value) {
                      print(value);
                    },
                    items: const ['English', 'Português'],
                    selectedItem: 'English',
                    popupProps: const PopupProps.dialog(
                      constraints: BoxConstraints(maxHeight: 130),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ssl_monitor/controller/auth_controller.dart';
import 'package:ssl_monitor/custom_widget/custom_button.dart';
import 'package:ssl_monitor/custom_widget/custom_text.dart';
import 'package:ssl_monitor/custom_widget/custom_text_field.dart';
import 'package:ssl_monitor/utils/utils.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  void dispose() {
    Get.delete<AuthController>();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: 'Create account'),
        backgroundColor: purple,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.focusScope!.unfocus();
            },
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: CustomTextField(
                            onChanged: authController.setFirstName,
                            hintText: 'First name',
                            fillColor: purple,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: CustomTextField(
                            onChanged: authController.setLastName,
                            hintText: 'Last name',
                            fillColor: purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      onChanged: authController.setUsername,
                      hintText: 'Username',
                      fillColor: purple,
                      textCapitalization: TextCapitalization.none,
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => CustomTextField(
                        onChanged: authController.setPassword,
                        hintText: 'Password',
                        fillColor: purple,
                        obscureText: authController.isPasswordObscured,
                        suffixIcon: authController.isPasswordObscured
                            ? LineIcons.eye
                            : LineIcons.eyeSlash,
                        onPressed: authController.togglePasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => CustomTextField(
                        onChanged: authController.setRepeatPassword,
                        hintText: 'Repeat password',
                        fillColor: purple,
                        obscureText: authController.isRepeatPasswordObscured,
                        suffixIcon: authController.isRepeatPasswordObscured
                            ? LineIcons.eye
                            : LineIcons.eyeSlash,
                        onPressed:
                            authController.toggleRepeatPasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Obx(
                      () => CustomButton(
                        onPressed: authController.isCreateAccountButtonEnabled
                            ? authController.create
                            : () {},
                        text: 'Create new account',
                        buttonColor: authController.isCreateAccountButtonEnabled
                            ? purple
                            : purple.withAlpha(950),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

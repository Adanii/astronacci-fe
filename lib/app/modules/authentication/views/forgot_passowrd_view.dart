import 'package:astronacci_fe/app/constant/app_color.dart';
import 'package:astronacci_fe/app/constant/app_spacing.dart';
import 'package:astronacci_fe/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:astronacci_fe/app/widgets/custom_elevated_button.dart';
import 'package:astronacci_fe/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ForgotPassowrdView extends GetView<AuthenticationController> {
  const ForgotPassowrdView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Forgot Password ?"),
            AppSpace.h10,
            CustomTextField(
              hintText: "Type your email account ...",
              controller: controller.emailController,
            ),
            AppSpace.h10,
            CustomElevatedButton(
              backgroundColor: AppColor.buttonPrimary,
              text: "Send",
              onPressed: () {
                controller.sendForgotPasswordEmail(
                  controller.emailController.text,
                );
              },
              icon: Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

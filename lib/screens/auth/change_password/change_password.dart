import 'package:flutter/material.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/components/custom_button.dart';
import 'package:link_on/components/custom_form_field.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/viewModel/api_client.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  bool doPasswordsMatch() {
    return newPasswordController.text == confirmPasswordController.text;
  }

  Future changePasswordReq() async {
    customDialogueLoader(context: context);

    const url = 'change-password';
    final Map<String, dynamic> mapData = {
      'old_password': oldPasswordController.text,
      'new_password': newPasswordController.text,
      'confirm_password': confirmPasswordController.text
    };
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    if (mounted) {
      Navigator.pop(context);
    }
    if (res['code'] == "200") {
      toast(
        res['message'],
      );
    } else {
      toast(
        res['message'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          translate(context, AppString.change_password).toString(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    alignment: Alignment.center,
                    height: MediaQuery.sizeOf(context).height * 0.2,
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    child: Image.network(
                      getStringAsync("appLogo"),
                    ),
                  ),
                  CustomFormField(
                    controller: oldPasswordController,
                    readOnly: false,
                    labelText: translate(context, AppString.your_old_password),
                    hintText:
                        translate(context, AppString.enter_your_old_password),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return translate(
                            context, AppString.enter_your_old_password);
                      }
                      return null;
                    },
                    icon: Icons.password,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    readOnly: false,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return translate(
                            context, AppString.enter_your_new_password);
                      }
                      return null;
                    },
                    isOutlineBorder: true,
                    labelText: translate(context, AppString.your_new_password),
                    hintText:
                        translate(context, AppString.enter_your_new_password),
                    icon: Icons.password,
                    controller: newPasswordController,
                    isPasswordField: true,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    readOnly: false,
                    isOutlineBorder: true,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return translate(
                            context, AppString.enter_your_confirm_password);
                      }
                      return null;
                    },
                    labelText:
                        translate(context, AppString.confirm_your_password),
                    hintText: translate(
                        context, AppString.enter_your_confirm_password),
                    icon: Icons.password,
                    controller: confirmPasswordController,
                    isPasswordField: true,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  CustomButton(
                    color: Colors.black,
                    text: translate(context, AppString.change_password),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (doPasswordsMatch() == false) {
                          toast('Your Passwords Are Not Matched');
                        } else {
                          changePasswordReq();
                        }
                      }
                    },
                    isGradient: true,
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

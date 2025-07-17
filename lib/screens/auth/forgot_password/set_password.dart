import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:link_on/components/custom_button.dart';
import 'package:link_on/components/custom_form_field.dart';
import 'package:link_on/utils/slide_navigation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/screens/auth/login/login.page.dart';
import 'package:link_on/viewModel/api_client.dart';

class SetPassword extends StatefulWidget {
  final TextEditingController emailController;

  const SetPassword({super.key, required this.emailController});

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    otpController.dispose();
    widget.emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool doPasswordsMatch() {
    return passwordController.text == confirmPasswordController.text;
  }

  Future submitResetPasswordRequest() async {
    customDialogueLoader(context: context);
    String url = 'reset-password-confirm';
    Map<String, dynamic> mapData = {
      "email": widget.emailController.text,
      "reset_code": otpController.text,
      "password": passwordController.text,
      "confirm_password": confirmPasswordController.text
    };
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    if (res['code'] == "400") {
      if (mounted) {
        Navigator.pop(context);
        toast(res['message'].toString(), bgColor: Colors.red);
      }
    } else {
      toast(res['message']);
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                          onTap: () => Navigator.of(context)
                              .pushReplacement(createRoute(LoginPage())),
                          child: Icon(Icons.arrow_back_ios)),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    alignment: Alignment.center,
                    height: MediaQuery.sizeOf(context).height * 0.25,
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: SvgPicture.asset("assets/images/reset-pass.svg"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomFormField(
                    enabled: false,
                    readOnly: true,
                    isOutlineBorder: true,
                    labelText: widget.emailController.text,
                    icon: Icons.mail,
                    color: Colors.black,
                  ),
                  CustomFormField(
                    readOnly: false,
                    isOutlineBorder: true,
                    labelText: "OTP ",
                    hintText: 'Enter OTP Code sent in Your Mail',
                    icon: Icons.lock_reset,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter OTP Code sent in Your Mail';
                      }
                      return null;
                    },
                    controller: otpController,
                    isPasswordField: true,
                    color: Colors.black,
                  ),
                  CustomFormField(
                    readOnly: false,
                    isOutlineBorder: true,
                    labelText: "Your Password",
                    hintText: 'Enter Your Password',
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter Your Password';
                      }
                      return null;
                    },
                    icon: Icons.password,
                    controller: passwordController,
                    isPasswordField: true,
                    color: Colors.black,
                  ),
                  CustomFormField(
                    readOnly: false,
                    isOutlineBorder: true,
                    labelText: "Confirm password",
                    hintText: 'Confirm Your Password',
                    icon: Icons.password,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Confirm Your Password';
                      }
                      return null;
                    },
                    controller: confirmPasswordController,
                    isPasswordField: true,
                    color: Colors.black,
                  ),
                  CustomButton(
                    color: Colors.black,
                    text: "Submit",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (doPasswordsMatch() == false) {
                          toast("Your PASSWORDS ARE NOT MATCHING",
                              bgColor: Colors.red);
                        } else {
                          submitResetPasswordRequest();
                        }
                      }
                    },
                    isGradient: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    text: "Send otp again",
                    onPressed: () {
                      otpController.clear();
                      passWordReset();
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

  Future passWordReset() async {
    customDialogueLoader(context: context);
    String url = 'reset-password';
    Map<String, dynamic> mapData = {
      "email": widget.emailController.text.trim(),
    };
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);

    if (res != null) {
      if (mounted) {
        toast('Otp code have been sent to your email.');
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}

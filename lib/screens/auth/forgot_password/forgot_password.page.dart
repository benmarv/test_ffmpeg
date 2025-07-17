import 'package:flutter_svg/flutter_svg.dart';
import 'package:link_on/components/auth_base_view.dart';
import 'package:link_on/components/custom_button.dart';
import 'package:link_on/components/custom_form_field.dart';
import 'package:link_on/components/header_text.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/utils/utils.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/screens/auth/forgot_password/set_password.dart';
import 'package:flutter/material.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController email = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  Future passWordReset() async {
    customDialogueLoader(context: context);
    String url = 'reset-password';
    Map<String, dynamic> mapData = {
      "email": email.text.trim(),
    };
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);

    if (res != null) {
      if (mounted) {
        toast('Otp code have been sent to your email.');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPassword(
              emailController: email,
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = Container(
      margin: const EdgeInsets.only(top: 50.0),
      alignment: Alignment.center,
      height: MediaQuery.sizeOf(context).height * 0.32,
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: SvgPicture.asset("assets/images/forgot-pass.svg"),
    );

    final title = HeaderText(
      text: translate(context, 'password_recovery_title'),
    );

    final emailField = CustomFormField(
      color: Colors.black,
      labelText: translate(context, 'email_address'),
      hintText: translate(context, 'enter_your_email_address'),
      icon: LineIcons.envelope,
      controller: email,
      validator: (val) {
        if (val!.isEmpty) {
          return translate(context, 'email_required');
        }
        if (!isValidEmail(val)) {
          return translate(context, 'email_invalid');
        }
        return null;
      },
      isOutlineBorder: true,
    );

    final button = CustomButton(
      color: Colors.black,
      text: translate(context, 'send_email_button'),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          passWordReset();
        }
      },
      isGradient: true,
    );

    final form = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Utils.verticalSpacer(space: 20.0),
          emailField,
          button,
        ],
      ),
    );

    return AuthBaseView(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 0.0,
            bottom: 30.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios)),
                ],
              ),
              image,
              title,
              // subtitle,
              form
            ],
          ),
        ),
      ),
    );
  }
}

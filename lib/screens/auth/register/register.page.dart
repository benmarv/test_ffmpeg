import 'package:intl/intl.dart';
import 'package:link_on/components/auth_base_view.dart';
import 'package:link_on/components/custom_button.dart';
import 'package:link_on/components/login_form_field.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/controllers/auth/auth_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/auth/login/login.page.dart';
import 'package:link_on/utils/slide_navigation.dart';
import 'package:link_on/utils/utils.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController last = TextEditingController();
  TextEditingController first = TextEditingController();

  bool containsEmoji(String input) {
    final emojiRegex = RegExp(
      r"[\u{1F600}-\u{1F64F}" // Emoticons
      r"\u{1F300}-\u{1F5FF}" // Misc Symbols and Pictographs
      r"\u{1F680}-\u{1F6FF}" // Transport and Map Symbols
      r"\u{1F700}-\u{1F77F}" // Alchemical Symbols
      r"\u{1F780}-\u{1F7FF}" // Geometric Shapes Extended
      r"\u{1F800}-\u{1F8FF}" // Supplemental Arrows-C
      r"\u{1F900}-\u{1F9FF}" // Supplemental Symbols and Pictographs
      r"\u{1FA00}-\u{1FA6F}" // Chess Symbols
      r"\u{1FA70}-\u{1FAFF}" // Symbols and Pictographs Extended-A
      r"\u{2600}-\u{26FF}" // Misc Symbols
      r"\u{2700}-\u{27BF}" // Dingbats
      r"]+",
      unicode: true,
    );
    return emojiRegex.hasMatch(input);
  }

  Future<void> register(String? timeZone) async {
    toast(translate(context, 'processing_data').toString(),
        bgColor: Colors.green.shade300);
    dynamic res = await apiClient.registerUser(
        date: _dateController.text,
        first: first.text,
        last: last.text,
        gender: dropdwongender,
        email: email.text,
        username: username.text,
        password: password.text,
        confirmPassword: confirmPassword.text,
        timeZone: timeZone);
    log('register res $res');
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    if (res['status'] == '200') {
      toast(res['message'],
          bgColor: Colors.green.shade300, length: Toast.LENGTH_LONG);
      if (mounted) {
        Navigator.of(context).pushNamed(
          AppRoutes.login,
        );
      }
      await setValue("user_id", res["user_id"]);
      getUserData();
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            content: Text(
              res["messages"]['error'],
              textAlign: TextAlign.center,
            ),
            actions: [
              MaterialButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        );
      }
    }
  }

  final _firstFormKey = GlobalKey<FormState>();
  final _thirdFormKey = GlobalKey<FormState>();
  final defaultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.5),
    ),
  );

  Future<void> getUserData() async {
    dynamic res = await apiClient.get_user_data();
    if (res["code"] == '200') {
      await setValue("userData", res["data"]);
      await setValue('user_first_name', res["data"]['first_name']);

      Navigator.of(context).pushReplacementNamed(
        AppRoutes.tabs,
      );
    } else {
      log('Error : ${res['message']}');
    }
  }

  @override
  void dispose() {
    email.dispose();
    username.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

//   final subtitle = HeaderText(
//   text: translate(context, 'create_an_account_to_continue'), // Translated text
//   isBig: false,
// );

  @override
  Widget build(BuildContext context) {
    final title = Row(
      children: [
        Text(
          translate(context, 'sign_up').toString(),
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          textAlign: TextAlign.left,
        ),
      ],
    );
    final image = Container(
      margin: const EdgeInsets.only(top: 50.0, bottom: 20),
      alignment: Alignment.center,
      height: MediaQuery.sizeOf(context).height * 0.3,
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: LottieBuilder.asset('assets/images/login-lottie.json'),
    );
    return AuthBaseView(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 30.0,
          bottom: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                InkWell(
                    onTap: () => Navigator.of(context)
                        .pushReplacement(createRoute(LoginPage())),
                    child: Icon(Icons.arrow_back_ios)),
              ],
            ),
            image,
            title,
            selectsection == "First"
                ? Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _firstFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Utils.verticalSpacer(space: 10.0),
                        LoginFormField(
                          controller: first,
                          suffixIcon: Icon(LineIcons.user),
                          hintText: translate(
                              context, 'first_name'), // Translated hint
                          validator: (value) {
                            // Check if this field is empty
                            if (value == null || value.isEmpty) {
                              return translate(context, 'first_name_required');
                            }

                            // Regular expression to ensure first name contains only letters and spaces
                            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                              return translate(
                                  context, 'first_name_only_letters_spaces');
                            }

                            // Ensure the name is not too short or too long
                            if (value.length < 2) {
                              return translate(
                                  context, 'first_name_min_length');
                            }

                            if (value.length > 12) {
                              return translate(
                                  context, 'first_name_max_length');
                            }

                            // The first name is valid
                            return null;
                          },
                        ),
                        Utils.verticalSpacer(space: 10.0),
                        LoginFormField(
                          controller: last,
                          suffixIcon: Icon(LineIcons.user),
                          hintText: translate(
                              context, 'last_name'), // Translated hint
                          validator: (value) {
                            // Check if this field is empty
                            if (value == null || value.isEmpty) {
                              return translate(context, 'last_name_required');
                            }

                            // Regular expression to ensure last name contains only letters and spaces
                            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                              return translate(
                                  context, 'last_name_only_letters_spaces');
                            }

                            // Ensure the name is not too short or too long
                            if (value.length < 2) {
                              return translate(context, 'last_name_min_length');
                            }

                            if (value.length > 12) {
                              return translate(context, 'last_name_max_length');
                            }

                            // The last name is valid
                            return null;
                          },
                        ),
                        Utils.verticalSpacer(space: 10.0),
                        LoginFormField(
                          controller: username,
                          suffixIcon: Icon(LineIcons.user),
                          hintText:
                              translate(context, 'username'), // Translated hint
                          validator: (val) {
                            // Check if the field is empty
                            if (val == null || val.isEmpty) {
                              return translate(context, 'username_required');
                            }

                            // Check if the username is too short
                            if (val.length < 3) {
                              return translate(context, 'username_min_length');
                            }

                            // Check if the username is too long
                            if (val.length > 20) {
                              return translate(context, 'username_max_length');
                            }

                            // Regular expression to allow only alphanumeric characters (letters and numbers)
                            // This regex also prevents spaces
                            RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
                            if (!regex.hasMatch(val)) {
                              return translate(
                                  context, 'username_invalid_format');
                            }

                            // The username is valid
                            return null;
                          },
                        ),
                        Utils.verticalSpacer(space: 10.0),
                        LoginFormField(
                          controller: email,
                          suffixIcon: Icon(LineIcons.at),
                          hintText: translate(
                              context, 'email_address'), // Translated hint
                          validator: (value) {
                            // Check if this field is empty
                            if (value == null || value.isEmpty) {
                              return translate(context, 'email_required');
                            }

                            // Validate email format using a regular expression
                            if (!RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                              return translate(context, 'email_invalid');
                            }

                            // The email is valid
                            return null;
                          },
                        ),
                        Utils.verticalSpacer(space: 10.0),
                        CustomButton(
                          text: translate(
                              context, 'next'), // Translated "Next" text
                          onPressed: () {
                            if (_firstFormKey.currentState!.validate()) {
                              if (first.text.isEmpty) {
                                toast(
                                    translate(context, 'enter_first_name')
                                        .toString(), // Translated message
                                    bgColor: Colors.red);
                              } else if (first.text.length < 3) {
                                toast(
                                    translate(context, 'first_name_min_length')
                                        .toString(), // Translated message
                                    bgColor: Colors.red);
                              } else if (last.text.isEmpty) {
                                toast(
                                    translate(context, 'enter_last_name')
                                        .toString(), // Translated message
                                    bgColor: Colors.red);
                              } else if (last.text.length < 3) {
                                toast(
                                    translate(context, 'last_name_min_length')
                                        .toString(), // Translated message
                                    bgColor: Colors.red);
                              } else if (email.text.isEmpty) {
                                toast(
                                    translate(context, 'email_required')
                                        .toString(), // Translated message
                                    bgColor: Colors.red);
                              } else if (!email.text.contains('@')) {
                                toast(
                                    translate(context, 'email_invalid')
                                        .toString(), // Translated message
                                    bgColor: Colors.red);
                              } else if (username.text.isEmpty) {
                                toast(
                                    translate(context, 'username_required')
                                        .toString(), // Translated message
                                    bgColor: Colors.red);
                              } else {
                                selectsection = "second";
                                setState(() {});
                              }
                            }
                          },
                          isGradient: true,
                        ),
                        navigateToLogin(context),
                      ],
                    ),
                  )
                : selectsection == "second"
                    ? Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _thirdFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Utils.verticalSpacer(space: 30.0),
                            InkWell(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: InkWell(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: LoginFormField(
                                  isEnabled: false,
                                  suffixIcon: Icon(LineIcons.calendar),
                                  controller: _dateController,
                                  hintText: translate(context,
                                      'date_of_birth'), // Translated "Date of Birth"
                                  validator: (val) {
                                    // Check if the field is empty
                                    if (val == null || val.isEmpty) {
                                      return translate(context,
                                          'select_date_of_birth'); // Translated message
                                    }

                                    // Check if the entered date is in a valid format (e.g., YYYY-MM-DD)
                                    RegExp regex =
                                        RegExp(r'^\d{4}-\d{2}-\d{2}$');
                                    if (!regex.hasMatch(val)) {
                                      return translate(context,
                                          'dob_invalid_format'); // Translated message
                                    }

                                    // Parse the date
                                    DateTime? dob;
                                    try {
                                      dob = DateTime.parse(val);
                                    } catch (e) {
                                      return translate(context,
                                          'dob_invalid_date'); // Translated message
                                    }

                                    // Check if the date is in the future
                                    if (dob.isAfter(DateTime.now())) {
                                      return translate(context,
                                          'dob_future_error'); // Translated message
                                    }

                                    // Check if the user is at least 15 years old
                                    DateTime today = DateTime.now();
                                    int age = today.year - dob.year;
                                    if (today.month < dob.month ||
                                        (today.month == dob.month &&
                                            today.day < dob.day)) {
                                      age--;
                                    }
                                    if (age < 15) {
                                      return translate(context,
                                          'dob_age_limit'); // Translated message
                                    }

                                    // The date of birth is valid
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Utils.verticalSpacer(space: 10.0),
                            dropDwonGender(),
                            Utils.verticalSpacer(space: 10.0),
                            LoginFormField(
                              isPasswordField: true,
                              suffixIcon: Icon(LineIcons.lock),
                              hintText: translate(
                                  context, 'password'), // Translated "Password"
                              controller: password,
                              validator: (val) {
                                // Check if the password field is empty
                                if (val == null || val.isEmpty) {
                                  return translate(context,
                                      'password_required'); // Translated message
                                }

                                // Check the password length (at least 8 characters)
                                if (val.length < 8) {
                                  return translate(context,
                                      'password_min_length'); // Translated message
                                }

                                // Check if the password contains at least one uppercase letter
                                if (!RegExp(r'[A-Z]').hasMatch(val)) {
                                  return translate(context,
                                      'password_uppercase'); // Translated message
                                }

                                // Check if the password contains at least one lowercase letter
                                if (!RegExp(r'[a-z]').hasMatch(val)) {
                                  return translate(context,
                                      'password_lowercase'); // Translated message
                                }

                                // Check if the password contains at least one special character
                                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                    .hasMatch(val)) {
                                  return translate(context,
                                      'password_special_character'); // Translated message
                                }

                                // The password is valid
                                return null;
                              },
                            ),
                            Utils.verticalSpacer(space: 10.0),
                            LoginFormField(
                              isPasswordField: true,
                              suffixIcon: Icon(LineIcons.lock),
                              hintText: translate(context,
                                  'confirm_password'), // Translated "Confirm Password"
                              controller: confirmPassword,
                              validator: (val) {
                                // Check if the confirm password field is empty
                                if (val == null || val.isEmpty) {
                                  return translate(context,
                                      'confirm_password_required'); // Translated message
                                }

                                // Check if the confirm password matches the original password
                                if (val != password.text) {
                                  return translate(context,
                                      'passwords_do_not_match'); // Translated message
                                }

                                // The confirm password is valid
                                return null;
                              },
                            ),
                            Utils.verticalSpacer(space: 10.0),
                            Utils.verticalSpacer(space: 20.0),
                            CustomButton(
                              text: translate(
                                  context, 'sign_up'), // Translated "Sign Up"
                              onPressed: () async {
                                final timezoneProvider =
                                    Provider.of<AuthProvider>(context,
                                        listen: false);
                                if (_thirdFormKey.currentState!.validate()) {
                                  if (!email.text.contains('@')) {
                                    toast(translate(context,
                                        'email_invalid')); // Translated message
                                  } else if (containsEmoji(username.text)) {
                                    toast(translate(context,
                                        'emoji_in_username')); // Translated message
                                  } else if (confirmPassword.text !=
                                      password.text) {
                                    toast(translate(context,
                                        'passwords_do_not_match')); // Translated message
                                  } else {
                                    if (!await Provider.of<AuthProvider>(
                                            context,
                                            listen: false)
                                        .checkInternetConnection()) {
                                      return null;
                                    }

                                    await register(
                                        timezoneProvider.localTimezone);
                                  }
                                }
                              },
                              isGradient: true,
                            ),
                            navigateToLogin(context),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Container navigateToLogin(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: translate(context,
              'already_have_account'), // Translated "Already have an account?"
          style: Theme.of(context).textTheme.bodySmall,
          children: <TextSpan>[
            TextSpan(
              text: translate(context, 'login'), // Translated "Login"
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context)
                      .pushReplacement(createRoute(LoginPage()));
                },
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final age = DateTime.now().difference(picked).inDays ~/ 365;

      if (age < 15) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(translate(context, 'invalid_dob')
                    .toString()), // Translated "Invalid Date of Birth"
                content: Text(
                  translate(context, 'dob_message')
                      .toString(), // Translated message
                  textAlign: TextAlign.justify,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                        translate(context, 'ok').toString()), // Translated "OK"
                  ),
                ],
              );
            },
          );
        }
      } else {
        setState(() {
          selectedDate = picked;
          _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        });
      }
    }
  }

  String selectsection = "First";
  List relation = [
    "female",
    "male",
  ];
  int? genderindex;
  String? dropdwongender;
  Widget dropDwonGender() {
    return DropdownButtonFormField<String>(
      padding: EdgeInsets.zero,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
      ),
      hint: Text(
        translate(context, 'select_gender')
            .toString(), // Translated "Select Gender"
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
      value: dropdwongender,
      isExpanded: true,
      dropdownColor: Theme.of(context).colorScheme.secondary,
      iconSize: 30.0,
      icon: Icon(LineIcons.male),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      items: relation.map((val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(
            translate(context, val).toString(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        );
      }).toList(),
      onChanged: (String? val) {
        setState(() {
          dropdwongender = val;
          genderindex = relation.indexOf(val!);
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return translate(context,
              'please_select_gender'); // Translated "Please select a gender"
        }
        return null;
      },
    );
  }
}

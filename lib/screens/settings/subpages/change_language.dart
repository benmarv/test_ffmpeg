import 'package:flutter/material.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/main.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  int? value;
  bool loading = false;
  String userName = "";
  String userPhoneCode = "";
  String userPhoneNo = "";
  String? userDateOfBirth = "";
  String userGender = "";

  @override
  void initState() {
    log("current language code ${getStringAsync("current_language_code")}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          translate(context, AppString.change_language).toString(),
          // 'Change Language',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
            new FocusNode(),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: ListView.builder(
            itemCount: Language.languageList().length,
            padding: EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              value = 0;
              value = Language.languageList()[index].languageCode ==
                      getStringAsync("current_language_code")
                  ? index
                  : null;
              if (getStringAsync('current_language_code') == 'N/A') {
                value = 0;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.1),
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RadioListTile(
                          value: index,
                          controlAffinity: ListTileControlAffinity.trailing,
                          groupValue: value,
                          activeColor: AppColors.primaryColor,
                          onChanged: (int? val) async {
                            Locale local = await setLocale(
                                Language.languageList()[index].languageCode);
                            setState(() {
                              this.value = value;
                              App.setLocale(context, local);

                              setValue(
                                "current_language_code",
                                Language.languageList()[index].languageCode,
                              );
                            });
                            await updateLanguage(
                              Language.languageList()[index].languageCode,
                            );
                          },
                          title: Text(
                            Language.languageList()[index].name,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future updateLanguage(languageCode) async {
    await apiClient.callApiCiSocial(
      apiPath: 'update-user-profile',
      apiData: {
        'lang': languageCode,
      },
    );
  }
}

class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, 'English', 'US', 'en'),
      Language(2, 'Spanish', 'ES', 'es'),
      Language(3, 'Arabic', 'AE', 'ar'),
      Language(3, 'Urdu', 'PK', 'ur'),
      Language(4, 'German', 'DE', 'de'),
      Language(5, 'French', 'FR', 'fr'),
      Language(5, 'Chinese', 'CN', 'zh'),
      Language(6, 'Dutch', 'NL', 'nl'),
    ];
  }
}

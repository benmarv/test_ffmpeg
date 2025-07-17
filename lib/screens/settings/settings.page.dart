import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/consts/appconfig.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/controllers/theme_controller.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/session/get_sessions.dart';
import 'package:link_on/screens/settings/subpages/advertisement_requests.dart';
import 'package:link_on/screens/settings/subpages/change_language.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/screens/auth/change_password/change_password.dart';
import 'package:link_on/screens/settings/subpages/account.subpage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'subpages/block_userlist.dart';
import 'widgets/icon_tile.dart';
import 'widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingsPage extends StatefulWidget {
  final String? id;
  final String? userName;
  const SettingsPage({super.key, this.id, this.userName});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _passwordText = TextEditingController();
  SiteSetting? site;

  @override
  void initState() {
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
    super.initState();
  }

  @override
  void dispose() {
    _passwordText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> deleteAccount(context, {required String password}) async {
      try {
        var accessToken = getStringAsync("access_token");

        customDialogueLoader(context: context);

        FormData form = FormData.fromMap({'password': password});
        String? url = "delete-account";

        Response response = await dioService.dio.post(
          url,
          data: form,
          options: Options(
            headers: {"Authorization": 'Bearer $accessToken'},
          ),
        );
        var res = response.data;
        log("delete response ${res.toString()}");
        if (res["code"] == "200") {
          Navigator.pop(context);

          await removeKey("access_token");
          await removeKey("userData");
          await removeKey('access_token');
          // currentIndex = 0;

          Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.login, (Route<dynamic> route) => false);
          toast(res['message']);
        } else {
          Navigator.pop(context);

          toast(res['message']);
          log('Error: ${res['message']}');
        }
      } catch (e) {
        Navigator.pop(context);
        Navigator.pop(context);

        log('Error: $e');
      }
    }

    final themeChange = Provider.of<ThemeChange>(context, listen: false);

    const hr = Divider(
      thickness: 0.5,
    );

    final themeMode = SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      value: themeChange.currentTheme == ThemeMode.light ? false : true,
      onChanged: (value) {
        themeChange.toggleTheme();
      },
      title: Text(translate(context, 'enable_dark_mode')!),
    );

    final account = Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Header(
              text: translate(context, AppString.account).toString(),
            ),
          ),
          IconTile(
            icon: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey.withOpacity(0.1),
                child: Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                )),
            title: translate(context, AppString.update_profile).toString(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountSubpage(
                    id: widget.id,
                  ),
                ),
              );
            },
          ),
          IconTile(
              icon: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: Icon(
                    Icons.history_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 20,
                  )),
              title: translate(context, AppString.manage_sessions).toString(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SessionList(),
                  ),
                );
              }),
          IconTile(
              icon: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: Icon(
                    Icons.person_pin_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 20,
                  )),
              title: translate(context, AppString.share_profile).toString(),
              onTap: () {
                Share.share('${AppConfig.baseUrl}${widget.userName}');
              }),
          IconTile(
            icon: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey.withOpacity(0.1),
              child: Icon(
                Icons.person_off_outlined,
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
            ),
            title: translate(context, AppString.blocked_users).toString(),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const BlockUsers()));
            },
          ),
          IconTile(
            icon: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey.withOpacity(0.1),
              child: Icon(
                Icons.request_page_outlined,
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
            ),
            title:
                translate(context, AppString.advertisement_requests).toString(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdvertisementRequestPage(),
                ),
              );
            },
          ),
          IconTile(
            icon: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey.withOpacity(0.1),
              child: Icon(
                Icons.language,
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
            ),
            title: translate(context, AppString.change_language).toString(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeLanguage(),
                ),
              );
            },
          ),
          IconTile(
              icon: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey.withOpacity(0.1),
                child: Icon(
                  Icons.password_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
              ),
              title: translate(context, AppString.change_password).toString(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PasswordChangeScreen(),
                  ),
                );
              }),
          // if (site!.checkAccountDelete == '1')
          IconTile(
              icon: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey.withOpacity(0.1),
                child: Icon(
                  Icons.delete_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
              ),
              title: translate(context, AppString.delete_account).toString(),
              onTap: () async {
                await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Column(
                        children: [
                          Text(
                            translate(
                                    context,
                                    AppString
                                        .are_you_sure_you_want_to_delete_your_account)
                                .toString(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Material(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            borderRadius: BorderRadius.circular(10),
                            child: TextFormField(
                              controller: _passwordText,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              maxLines: 1,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return translate(context,
                                          AppString.password_is_required)
                                      .toString();
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                fillColor: Colors.grey.withOpacity(0.1),
                                hintText:
                                    translate(context, AppString.enter_password)
                                        .toString(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      actions: [
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            translate(context, AppString.cancel).toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          isDestructiveAction: true,
                          onPressed: () async {
                            if (_passwordText.text != '') {
                              if (widget.id != '1') {
                                await deleteAccount(context,
                                    password: _passwordText.text);
                              } else {
                                toast(translate(
                                    context, 'cannot_delete_demo_account')!);
                              }
                            } else {
                              toast(translate(context, 'password_required')!);
                            }
                          },
                          child: Text(
                            translate(context, AppString.delete).toString(),
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
          hr
        ],
      ),
    );

    final about = Container(
      margin: const EdgeInsets.only(top: 15.0, left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Header(
              text: translate(context, AppString.about).toString(),
            ),
          ),
          IconTile(
              icon: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: Icon(
                    Icons.privacy_tip_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
              title: translate(context, AppString.privacy_policy).toString(),
              onTap: () {
                final Uri url =
                    Uri.parse('${AppConfig.baseUrl}page/privacy-policy');
                launchUrl(url);
              }),
          IconTile(
              icon: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: Icon(
                    Icons.pages_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
              title: translate(context, AppString.terms_of_use).toString(),
              onTap: () {
                final Uri url =
                    Uri.parse('${AppConfig.baseUrl}page/terms-and-conditions');
                launchUrl(url);
              }),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          translate(context, AppString.settings_and_activity).toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (site!.themeCheck == '1') ...[themeMode],
            account,
            about,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/controllers/ReportActionProvider/report_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ReportUser extends StatefulWidget {
  final String? user;
  final String? groupid;
  final String? pageid;
  final String? postid;

  const ReportUser(
      {Key? key, this.user, this.groupid, this.pageid, this.postid})
      : super(key: key);

  @override
  State<ReportUser> createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {
  List reportdata = [
    "hate_speech",
    "nudity_or_sexual_content",
    "violence",
    "harassment",
    "fraud_or_scam",
    "fake_profile"
  ];

  Future<void> reportUser(String txtreport, String userid) async {
    Map<String, dynamic> dataArray = {
      "report_user_id": userid,
      "reason": txtreport,
    };

    log('User Id is ${userid}');
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'report-user', apiData: dataArray);

    if (res["code"] == 200) {
      toast(res['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            translate(context, 'report')!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(context, 'help_us_to_understand')!,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: reportdata.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Container(
                              child: CupertinoAlertDialog(
                                title: Text(translate(context, 'app_name')!),
                                content: Text(
                                  translate(context, 'confirm_report_message')!,
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      translate(context, 'cancel')!,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      translate(context, 'report')!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      if (widget.user != null) {
                                        reportUser(
                                            reportdata[index], widget.user!);
                                      } else if (widget.groupid != null) {
                                        Map<String, dynamic> mapData = {
                                          "group_id": widget.groupid,
                                          "text": reportdata[index]
                                              .toString()
                                              .trim(),
                                        };
                                        String url = "report_group";
                                        Provider.of<ReportActionpProvider>(
                                                context,
                                                listen: false)
                                            .reportAction(
                                                mapData: mapData,
                                                context: context,
                                                url: url);
                                      } else if (widget.pageid != null) {
                                        Map<String, dynamic> mapData = {
                                          "page_id": widget.pageid,
                                          "text": reportdata[index]
                                              .toString()
                                              .trim(),
                                        };
                                        String url = "report_page";
                                        Provider.of<ReportActionpProvider>(
                                                context,
                                                listen: false)
                                            .reportAction(
                                                mapData: mapData,
                                                context: context,
                                                url: url);
                                      } else if (widget.postid != null) {
                                        String url = "post/action";
                                        Map<String, dynamic> mapData = {
                                          "post_id": widget.postid,
                                          "action": "report",
                                          'text': reportdata[index]
                                              .toString()
                                              .trim()
                                        };
                                        Provider.of<ReportActionpProvider>(
                                                context,
                                                listen: false)
                                            .reportAction(
                                                mapData: mapData,
                                                context: context,
                                                url: url);
                                      }
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: ListTile(
                        title: Text(
                          translate(context, reportdata[index])!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/job_mdel/Apply_JobList_Model.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

class ApplyJobDetails extends StatefulWidget {
  final AppliedJobList candidatedata;
  const ApplyJobDetails({super.key, required this.candidatedata});

  @override
  State<ApplyJobDetails> createState() => _ApplyJobDetailsState();
}

class _ApplyJobDetailsState extends State<ApplyJobDetails> {
  Future<void> downloadResume() async {
    try {
      final externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        return;
      }
      final downloadsDir = Directory('${externalDir.path}/Downloads');
      if (!(await downloadsDir.exists())) {
        await downloadsDir.create(recursive: true);
      }
      final fullPath =
          '${downloadsDir.path}/${widget.candidatedata.username}resume.pdf';
      toast(translate(context, 'downloading'));
      final file = widget.candidatedata.cvFile!;
      await dioService.dio.download(
        file,
        fullPath,
      );
      toast(translate(context, 'downloaded'));
    } catch (e) {
      print('Resume Download Error: $e');
      // Handle exceptions or errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
          centerTitle: true,
          title: Text(
            translate(context, 'applicant_info')!,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 1,
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.grey.shade400)),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                          NetworkImage(widget.candidatedata.avatar.toString()),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate(context, 'profile')!,
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.candidatedata.username.toString(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            4.sw,
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.candidatedata.phone.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.email,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.candidatedata.email.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 300,
                          child: Text(
                            widget.candidatedata.location.toString(),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                overflow: TextOverflow.visible),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      translate(context, 'experience')!,
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Text(
                          translate(context, 'company_name')!,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.candidatedata.previousWork == ""
                              ? translate(context, 'not_given')!
                              : widget.candidatedata.previousWork.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Text(
                          translate(context, 'position')!,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.candidatedata.position == ''
                              ? translate(context, 'not_given')!
                              : widget.candidatedata.position.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Text(
                          translate(context, 'experience_description')!,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        if (widget.candidatedata.position == '')
                          Text(
                            '  ${translate(context, 'not_given')}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.candidatedata.description.toString(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    InkWell(
                      onTap: () {
                        downloadResume();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        width: MediaQuery.sizeOf(context).width * .3,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.file_present_sharp,
                                color: Colors.white,
                                size: 17,
                              ),
                              Text(
                                translate(context, 'download')!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  _CreatePollScreenState createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final TextEditingController pollTitleController = TextEditingController();
  final List<TextEditingController> pollOptionControllers = [];

  void addOption() {
    if (pollOptionControllers.length < 5) {
      setState(() {
        pollOptionControllers.add(TextEditingController());
      });
    } else {
      toast(translate(context, 'max_options_error'));
    }
  }

  void createPoll() async {
    customDialogueLoader(context: context);
    Map<String, dynamic> dataArray = {};

    dataArray['post_text'] = pollTitleController.text;
    List<String> pollOptions = [];

    for (TextEditingController controller in pollOptionControllers) {
      if (controller.text.isNotEmpty) {
        pollOptions.add(controller.text);
      } else {
        toast(translate(context, 'fill_all_options_error'));
        Navigator.pop(context);
        return;
      }
    }

    if (pollOptions.length < 2) {
      toast(translate(context, 'min_options_error'));
      Navigator.pop(context);
      return;
    }

    String formattedOptions = pollOptions.join(", ");
    dataArray['poll_option'] = formattedOptions;
    dataArray['privacy'] = 1;
    dataArray['post_type'] = 'poll';

    FormData form = FormData.fromMap(dataArray);

    try {
      var accessToken = getStringAsync("access_token");
      Response res = await dioService.dio.post(
        "post/create",
        data: form,
        cancelToken: cancelToken,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );
      if (res.data['code'] == '200') {
        toast(res.data['message']);

        for (TextEditingController controller in pollOptionControllers) {
          controller.clear();
        }
        pollTitleController.clear();
        final provider = Provider.of<GreetingsProvider>(context, listen: false);
        provider.setCurrentTabIndex(index: 2);

        Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TabsPage()))
            .then((value) {});
      } else {
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      Navigator.pop(context);

      log('create poll error : ${e.response?.data}');
    }
  }

  final defaultBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.2),
    ),
  );

  @override
  void initState() {
    final pro = Provider.of<PostProvider>(context, listen: false);
    if (pro.taggedUserIds.isNotEmpty || pro.taggedUserNames.isNotEmpty) {
      pro.taggedUserIds.clear();
      pro.taggedUserNames.clear();
    }
    super.initState();
  }

  @override
  void dispose() {
    pollTitleController.dispose();
    for (TextEditingController controller in pollOptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(context, 'create_poll_title')!),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: createPoll,
              child: Text(
                translate(context, 'create_button')!,
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                validator: (val) {
                  if (val!.isEmpty) {
                    return translate(context, 'required_field');
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                controller: pollTitleController,
                decoration: InputDecoration(
                  labelText: translate(context, 'poll_title_label'),
                  border: defaultBorder,
                  enabledBorder: defaultBorder,
                  focusedBorder: defaultBorder,
                  errorBorder: defaultBorder,
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: pollOptionControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return translate(context, 'required_field');
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              controller: pollOptionControllers[index],
                              decoration: InputDecoration(
                                labelText:
                                    '${translate(context, 'option_label')} ${index + 1}',
                                border: defaultBorder,
                                enabledBorder: defaultBorder,
                                focusedBorder: defaultBorder,
                                errorBorder: defaultBorder,
                                contentPadding: const EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.cancel_rounded,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                pollOptionControllers.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: addOption,
                child: Text(translate(context, 'add_option_button')!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:link_on/controllers/jobsProvider/joblist_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'widgets/jobs_data.dart';

class SearchJob extends StatefulWidget {
  const SearchJob({super.key});

  @override
  State<SearchJob> createState() => _SearchJobState();
}

class _SearchJobState extends State<SearchJob> {
  List categoryjobtype = [
    "full_time",
    "part_time",
    "internship",
    "volunteer",
    "contract",
  ];

  TextEditingController keyword = TextEditingController();

  int? jobtypedropindex;
  String? _jobtypedropDownValue;

  List categoryjob = [
    "Other",
    "Admin & Office",
    "Art & Design",
    "Business Operations",
    "Cleaning & Facilities",
    "Community & Social Services",
    "Computer & Data",
    "Construction & Mining",
    "Education",
    "Farming & Forestry",
    "Healthcare",
    "Installation, Maintenance & Repair",
    "Legal",
    "Management",
    "Manufacturing",
    "Media & Communication",
    "Personal Care",
    "Protective Services",
    "Restaurant & Hospitality",
    "Retail & Sales",
    "Science & Engineering",
    "Sports & Entertainment",
    "Transportation",
  ];

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    JobListProvider provider =
        Provider.of<JobListProvider>(context, listen: false);
    provider.setScreenName = "search";

    _controller.addListener(() {
      if ((_controller.position.pixels ==
              _controller.position.maxScrollExtent) &&
          provider.loading == false) {
        int afterPostId = provider.serchlist.length;
        provider.searchjob(
          afterPostId: afterPostId.toString(),
          keyword: keyword.text,
          jobType: _jobtypedropDownValue,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: Text(
            translate(context, 'search_jobs').toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<JobListProvider>().makeListEmpty();
            context.read<JobListProvider>().searchjob(
                keyword: keyword.text, jobType: _jobtypedropDownValue);
          },
          child: Consumer<JobListProvider>(builder: (context, value, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              child: Column(
                children: [
                  _serchWidget(),
                  if (value.loading == true && value.serchlist.isEmpty) ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ] else if (value.loading == false &&
                      value.serchlist.isEmpty) ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading(),
                        Text(translate(context, 'no_data_found').toString()),
                      ],
                    )
                  ] else ...[
                    JobsData(jobs: value.serchlist),
                  ]
                ],
              ),
            );
          }),
        ));
  }

  Widget _serchWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        border: Border.all(color: Colors.black12)),
                    child: CustomTextField(
                      controller: keyword,
                      textinputaction: TextInputAction.next,
                      maxLines: 1,
                      hinttext: translate(context, 'job_title').toString(),
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 50,
                  color: Theme.of(context).colorScheme.secondary,
                  child: dropDwonJobType(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: InkWell(
              splashColor: AppColors.primaryColor,
              onTap: () {
                if (keyword.text.isEmpty && _jobtypedropDownValue == null) {
                  toast(translate(context, 'input_fields_empty').toString());
                } else {
                  context.read<JobListProvider>().makeListEmpty();
                  context.read<JobListProvider>().searchjob(
                      keyword: keyword.text, jobType: _jobtypedropDownValue);
                }
              },
              child: Container(
                height: 40,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    translate(context, 'find_jobs').toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDwonJobType() {
    return Container(
      height: 47,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: _jobtypedropDownValue == null
                      ? Text(translate(context, 'job_type').toString())
                      : Text(
                          translate(context, _jobtypedropDownValue!).toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  items: categoryjobtype.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          translate(context, val)!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? val) {
                    setState(
                      () {
                        _jobtypedropDownValue = val;
                        ;
                        print("jobtypedropindex $_jobtypedropDownValue");
                        jobtypedropindex = categoryjobtype.indexOf(val);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

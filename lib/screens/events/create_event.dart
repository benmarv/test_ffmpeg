import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/controllers/EventsProvider/get_event_api_provider.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String? _hour, _minute, _time;
  final _formKey = GlobalKey<FormState>();
  String? dateTime;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime? startDateTime;
  DateTime? endDateTime;

  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _eventDetail = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _enddateController = TextEditingController();
  final TextEditingController _starttimeController = TextEditingController();
  final TextEditingController _endtimeController = TextEditingController();

  final defaultBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.5),
    ),
  );

  Future _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: startTime,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.green,
                ),
              ),
              child: child!);
        });
    if (picked != null) {
      setState(() {
        startTime = picked;
        _hour = startTime.hour.toString();
        _minute = startTime.minute.toString();
        _time = '${_hour!} : ${_minute!}';
        _starttimeController.text = _time!;
        _starttimeController.text = formatDate(
            DateTime(2019, 08, 1, startTime.hour, startTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  Future _endselectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: endTime,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.green,
                ),
              ),
              child: child!);
        });
    if (picked != null) {
      setState(() {
        endTime = picked;
        _hour = endTime.hour.toString();
        _minute = endTime.minute.toString();
        _time = '${_hour!} : ${_minute!}';
        _endtimeController.text = _time!;
        _endtimeController.text = formatDate(
            DateTime(2019, 08, 1, endTime.hour, endTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(
        DateFormat.y().format(DateTime.now()).toInt(),
        DateFormat.M().format(DateTime.now()).toInt(),
        DateFormat.d().format(DateTime.now()).toInt(),
      ),
      lastDate: DateTime(2026),
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
      setState(() {
        startDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(startDate);
      });
    }
  }

  Future _endselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(
        DateFormat.y().format(DateTime.now()).toInt(),
        DateFormat.M().format(DateTime.now()).toInt(),
        DateFormat.d().format(DateTime.now()).toInt(),
      ),
      lastDate: DateTime(2026),
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
      setState(() {
        endDate = picked;

        _enddateController.text = DateFormat('yyyy-MM-dd').format(endDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  File? eventImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          translate(context, 'create_event').toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: eventImage != null
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.secondary,
                          image: DecorationImage(
                            image: FileImage(eventImage!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                        ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, right: 10),
                      child: Container(
                        height: 30,
                        width: 110,
                        color: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              XFile? image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                eventImage = File(image.path);
                                setState(() {});
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(
                                  Icons.add_to_photos,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                Text(
                                  translate(context, 'add_photo').toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  controller: _eventName,
                  giveDefaultBorder: true,
                  labelText: translate(context, 'event_name').toString(),
                  hinttext: translate(context, 'enter_event_name').toString(),
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return translate(context, 'enter_event_name').toString();
                    }
                    if (val.length < 3) {
                      return translate(context, 'title_min_limit');
                    }
                    if (val.length > 50) {
                      return translate(context, 'title_exceed_limit');
                    }
                    RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');
                    if (!regex.hasMatch(val)) {
                      return translate(context, 'event_title_valid').toString();
                    }
                    return null;
                  },
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: _dateController,
                          decoration: InputDecoration(
                            hintText: translate(context, 'start_date'),
                            labelText: translate(context, 'start_date'),
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return translate(context, 'required');
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: _starttimeController,
                          decoration: InputDecoration(
                            hintText: translate(context, 'start_time'),
                            labelText: translate(context, 'start_time'),
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return translate(context, 'required');
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _endselectDate(context);
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: _enddateController,
                          decoration: InputDecoration(
                            hintText: translate(context, 'end_date'),
                            labelText: translate(context, 'end_date'),
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return translate(context, 'required');
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _endselectTime(context);
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: _endtimeController,
                          decoration: InputDecoration(
                            hintText: translate(context, 'end_time'),
                            labelText: translate(context, 'end_time'),
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return translate(context, 'required');
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  controller: _location,
                  giveDefaultBorder: true,
                  labelText: translate(context, 'event_location'),
                  hinttext: translate(context, 'enter_event_location'),
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return translate(context, 'enter_event_location');
                    }
                    RegExp locationRegex = RegExp(r'^[a-zA-Z0-9,\s]+$');
                    if (!locationRegex.hasMatch(val)) {
                      return translate(context, 'location_invalid').toString();
                    }
                    return null;
                  },
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  controller: _eventDetail,
                  giveDefaultBorder: true,
                  labelText: translate(context, 'event_details'),
                  hinttext: translate(context, 'enter_event_details'),
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return translate(context, 'enter_event_details');
                    }
                    return null;
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      // Add your validation logic here
                      startDateTime = DateTime(
                        startDate.year,
                        startDate.month,
                        startDate.day,
                        startTime.hour,
                        startTime.minute,
                      );
                      endDateTime = DateTime(
                        endDate.year,
                        endDate.month,
                        endDate.day,
                        endTime.hour,
                        endTime.minute,
                      );
                      if (eventImage == null) {
                        toast(translate(context, "event_image_required"));
                      } else if (startDateTime!.isBefore(
                        DateTime.now(),
                      )) {
                        toast(translate(context, "start_time_must_be_future"));
                      } else if (startDateTime!
                          .isAtSameMomentAs(endDateTime!)) {
                        toast(translate(
                            context, "start_and_end_time_must_differ"));
                      } else if (endDateTime!.isBefore(startDateTime!)) {
                        toast(translate(context, "end_time_after_start"));
                      } else if (startDateTime!.isAfter(endDateTime!)) {
                        toast(translate(context, "start_time_before_end_time"));
                      } else if (endDateTime!
                          .isAfter(startDateTime!.add(Duration(days: 14)))) {
                        toast(translate(context, "end_date_within_14_days"));
                      } else {
                        await context
                            .read<GetEventApiProvider>()
                            .createEventApi(
                              context: context,
                              coverimage: eventImage?.path,
                              evetName: _eventName.text,
                              eventStartDate: _dateController.text,
                              eventEndDate: _enddateController.text,
                              eventStartTime: _starttimeController.text,
                              eventEndTime: _endtimeController.text,
                              eventDescription: _eventDetail.text,
                              eventLocation: _location.text,
                            );
                      }
                    }
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      height: 40,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          translate(context, 'create_event_button').toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/models/EventsModel/create_event.dart';
import 'package:link_on/controllers/EventsProvider/get_event_api_provider.dart';

class UpdateEvent extends StatefulWidget {
  final EventModel eventData;
  final int? index;
  final bool? isHomePost;
  final String? screenName;
  final bool? isProfilePost;
  const UpdateEvent({
    required this.eventData,
    this.index,
    this.isHomePost,
    this.isProfilePost,
    this.screenName,
  });

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  String? _hour, _minute, _time;

  String? dateTime;
  final _formKey = GlobalKey<FormState>();
  DateTime startDate = DateTime.now();
  final dateformat = DateFormat('yyyy-MM-dd');
  final defaultBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.5),
    ),
  );
  DateTime endDate = DateTime.now();
  TimeOfDay endTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay startTime = const TimeOfDay(hour: 00, minute: 00);
  DateTime? startDateTime;
  DateTime? endDateTime;
  TextEditingController? _eventName;
  TextEditingController? _eventDetail;
  TextEditingController? _location;
  TextEditingController? _dateController;
  TextEditingController? _enddateController;
  TextEditingController? _starttimeController;
  TextEditingController? _endtimeController;

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
        _starttimeController!.text = _time!;
        _starttimeController!.text = formatDate(
            DateTime(
              2019,
              08,
              1,
              startTime.hour,
              startTime.minute,
            ),
            [
              hh,
              ':',
              nn,
              " ",
              am,
            ]).toString();
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
        _endtimeController!.text = _time!;
        _endtimeController!.text = formatDate(
            DateTime(2019, 08, 1, endTime.hour, endTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  Future _selectDate(BuildContext context) async {
    log('Start Date ${startDate.toString()}');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(
          DateFormat.y().format(DateTime.now()).toInt(),
          DateFormat.M().format(DateTime.now()).toInt(),
          DateFormat.d().format(DateTime.now()).toInt(),
        ),
        lastDate: DateTime(2025),
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
      if (DateFormat.yMd().format(picked).toInt() >
          DateFormat.yMd().format(DateTime.now()).toInt()) {
        toast(translate(context, 'date_not_selected_correctly')!);
      }
      log("=======> ${DateFormat.yMd().format(DateTime.now())}");
      setState(() {
        startDate = picked;
        _dateController!.text = dateformat.format(startDate);
      });
    }
  }

  Future _endselectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime tomorrow = currentDate.add(const Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate.isBefore(tomorrow) ? tomorrow : endDate,
      firstDate: tomorrow,
      lastDate: DateTime(2025),
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
        _enddateController!.text = dateformat.format(endDate);
      });
    }
  }

  TimeOfDay convertStringToTimeOfDay(String timeString) {
    // Split the timeString into hours, minutes, and AM/PM
    List<String> timeParts = timeString.split(' ');
    List<String> hourMinuteParts = timeParts[0].split(':');

    // Parse hours and minutes
    int hour = int.parse(hourMinuteParts[0]);
    int minute = int.parse(hourMinuteParts[1]);

    // Adjust hour if it's PM
    if (timeParts[1] == 'PM' && hour < 12) {
      hour += 12;
    }

    // Return TimeOfDay object
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void initState() {
    super.initState();
    _eventName = TextEditingController(
      text: widget.eventData.name.toString(),
    );
    _eventDetail = TextEditingController(
      text: widget.eventData.description.toString(),
    );
    _location = TextEditingController(
      text: widget.eventData.location.toString(),
    );
    _dateController = TextEditingController(
      text: widget.eventData.startDate!,
    );
    _enddateController = TextEditingController(
      text: widget.eventData.endDate!,
    );
    _starttimeController = TextEditingController(
      text: widget.eventData.startTime.toString(),
    );
    _endtimeController = TextEditingController(
      text: widget.eventData.endTime.toString(),
    );
    startDate =
        DateTime.tryParse(Utils.formatTimestamp(widget.eventData.startDate!))!;
    endDate =
        DateTime.tryParse(Utils.formatTimestamp(widget.eventData.endDate!))!;
    startTime = convertStringToTimeOfDay(_starttimeController!.text);
    endTime = convertStringToTimeOfDay(_endtimeController!.text);
  }

  File? eventImage;

  // cusotmDialouge(contex, {eventId, eventIndex}) {
  //   return showDialog(
  //     barrierDismissible: true,
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(translate(context, 'delete_event')!),
  //       content: Text(translate(context, 'confirm_delete_event')!),
  //       actions: <Widget>[
  //         CupertinoDialogAction(
  //           onPressed: () {
  //             context.read<GetEventApiProvider>().deleteEvents(
  //                 screenName: widget.isHomePost == true
  //                     ? "home"
  //                     : widget.isProfilePost == true
  //                         ? "profile"
  //                         : widget.screenName,
  //                 eventId: eventId,
  //                 eventIndex: eventIndex,
  //                 context: context,
  //                 isEventDetailScreen: true);
  //             Navigator.pop(context);
  //           },
  //           isDefaultAction: true,
  //           child: Text(
  //             translate(context, 'delete')!,
  //             style: const TextStyle(color: Colors.red),
  //           ),
  //         ),
  //         CupertinoDialogAction(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: Text(translate(context, 'go_back')!),
  //         )
  //       ],
  //     ),
  //   );
  // }

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
          translate(context, 'update_event')!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       cusotmDialouge(context,
        //           eventId: widget.eventData.id, eventIndex: widget.index);
        //     },
        //     child: const Padding(
        //       padding: EdgeInsets.only(right: 10),
        //       child: Icon(
        //         Icons.delete,
        //         color: Colors.red,
        //         size: 25,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    // ignore: invalid_use_of_visible_for_testing_member
                    PickedFile? image = await ImagePicker.platform
                        .pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      eventImage = File(image.path);
                      setState(() {});
                    }
                  },
                  child: Container(
                    height: 200,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: eventImage == null
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                            image: DecorationImage(
                              image: NetworkImage(
                                  widget.eventData.cover.toString()),
                              fit: BoxFit.cover,
                            ),
                          )
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                            image: DecorationImage(
                              image: FileImage(eventImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        giveDefaultBorder: true,
                        labelText: translate(context, 'event_name')!,
                        controller: _eventName,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return translate(context, 'update_event_name')!;
                          }
                          // Regular expression to allow only alphanumeric characters (letters and numbers)
                          RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');
                          if (!regex.hasMatch(val)) {
                            return translate(
                                context, 'event_title_validation')!;
                          }
                          return null;
                        },
                        maxLines: null,
                        keyboardType: TextInputType.name,
                        hinttext: translate(context, 'update_event_name')!,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _dateController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return translate(context, 'required')!;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: translate(context, 'start_date')!,
                            labelText: translate(context, 'start_date')!,
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            border: defaultBorder,
                            focusedBorder: defaultBorder,
                            enabledBorder: defaultBorder,
                            errorBorder: defaultBorder,
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _starttimeController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return translate(context, 'required')!;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: translate(context, 'start_time')!,
                            labelText: translate(context, 'start_time')!,
                            border: defaultBorder,
                            focusedBorder: defaultBorder,
                            enabledBorder: defaultBorder,
                            errorBorder: defaultBorder,
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _endselectDate(context);
                        },
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _enddateController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return translate(context, 'required')!;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: translate(context, 'end_date')!,
                            labelText: translate(context, 'end_date')!,
                            border: defaultBorder,
                            focusedBorder: defaultBorder,
                            enabledBorder: defaultBorder,
                            errorBorder: defaultBorder,
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _endselectTime(context);
                        },
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                          enabled: false,
                          keyboardType: TextInputType.text,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return translate(context, 'required')!;
                            }
                            return null;
                          },
                          controller: _endtimeController,
                          decoration: InputDecoration(
                            hintText: translate(context, 'end_time')!,
                            labelText: translate(context, 'end_time')!,
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            border: defaultBorder,
                            focusedBorder: defaultBorder,
                            enabledBorder: defaultBorder,
                            errorBorder: defaultBorder,
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _location,
                        labelText: translate(context, 'event_address')!,
                        giveDefaultBorder: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return translate(context, 'update_address')!;
                          }
                          return null;
                        },
                        maxLines: null,
                        keyboardType: TextInputType.name,
                        hinttext: translate(context, 'update_address')!,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _eventDetail,
                        labelText: translate(context, 'event_details')!,
                        giveDefaultBorder: true,
                        maxLines: null,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return translate(context, 'update_event_details')!;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        hinttext: translate(context, 'update_event_details')!,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      log('Start Time.......${startTime.hour.toString()}');
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
                      // if (startDateTime!.isBefore(
                      //   DateTime.now(),
                      // )) {
                      //   log('Start Date .... ${startDateTime!.toIso8601String()}');
                      //   toast('start time cannot be in the past.');
                      // } else
                      if (startDateTime!.isAtSameMomentAs(endDateTime!)) {
                        toast(translate(
                            context, 'start_end_time_should_differ')!);
                      } else if (endDateTime!.isBefore(startDateTime!)) {
                        toast(translate(context, 'end_time_after_start')!);
                      } else if (startDateTime!.isAfter(endDateTime!)) {
                        toast(translate(context, 'start_time_before_end')!);
                      } else {
                        await context
                            .read<GetEventApiProvider>()
                            .updateEventApi(
                              eventId: widget.eventData.id,
                              context: context,
                              coverimage: eventImage?.path,
                              evetName: _eventName!.text,
                              eventStartDate: _dateController!.text,
                              eventEndDate: _enddateController!.text,
                              eventStartTime: _starttimeController!.text,
                              eventEndTime: _endtimeController!.text,
                              eventDescription: _eventDetail!.text,
                              eventLocation: _location!.text,
                            );
                      }
                    }
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      height: 45,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppColors.primaryColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        translate(context, 'update_event')!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
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

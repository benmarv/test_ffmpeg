import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key, this.user});
  final Usr? user;
  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
        title: Text(
          "${widget.user!.firstName} ${widget.user!.lastName}",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            data(
                icon: const Icon(
                  Icons.email,
                ),
                head: Text(
                  translate(context, 'email')!,
                ),
                child: InkWell(
                  onTap: () async {
                    await Clipboard.setData(
                        ClipboardData(text: widget.user!.email.toString()));
                    toast(translate(context, 'copied_successfully')!);
                  },
                  child: Text(
                    widget.user!.email.toString(),
                    style: const TextStyle(color: Colors.blue),
                  ),
                )),
            data(
              icon: const Icon(
                Icons.person,
              ),
              head: Text(
                translate(context, 'profile')!,
              ),
            ),
            data(
                icon: Icon(
                  widget.user!.gender == "Male" ? Icons.male : Icons.female,
                ),
                head: Text(
                  translate(context, 'gender')!,
                ),
                child: Text(
                  widget.user!.gender.toString(),
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                )),
            widget.user!.privacyBirthday == "1"
                ? const SizedBox.shrink()
                : widget.user!.dateOfBirth != null
                    ? data(
                        icon: const Icon(
                          Icons.cake,
                        ),
                        head: Text(
                          translate(context, 'birthday')!,
                        ),
                        child: Text(
                          "${widget.user?.dateOfBirth?.day} ${monthNames[widget.user!.dateOfBirth!.month - 1]} ${widget.user?.dateOfBirth?.year}",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget data({icon, head, child}) {
    return ListTile(
      leading: icon,
      title: head,
      subtitle: child,
    );
  }
}

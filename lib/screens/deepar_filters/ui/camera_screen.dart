import 'package:flutter/material.dart';
import 'package:link_on/consts/constants.dart';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:link_on/screens/deepar_filters/ui/widgets/filters.dart';
import 'package:link_on/screens/deepar_filters/ui/widgets/buttons_row.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.isPost});
  final bool isPost;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  final deepArController = DeepArController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      Navigator.pop(context);
      deepArController.destroy();
    } else if (state == AppLifecycleState.inactive) {
      //
    }
  }

  @override
  void dispose() {
    deepArController.destroy();
    super.dispose();
  }

  Future<void> initializeController() async {
    // deepArController.destroy();
    if (!deepArController.isInitialized) {
      await deepArController
          .initialize(
              androidLicenseKey: Constants.androidKey,
              iosLicenseKey: Constants.iosKey,
              resolution: Resolution.veryHigh)
          .then((value) {
        print("deepar initialized : ${value.toString()}");

        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: FutureBuilder(
        future: initializeController(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Transform.scale(
                    scale: 1.5,
                    child: DeepArPreview(deepArController),
                  ),
                ),
                Filters(deepArController: deepArController),
                ButtonsRow(
                    deepArController: deepArController, isPost: widget.isPost),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

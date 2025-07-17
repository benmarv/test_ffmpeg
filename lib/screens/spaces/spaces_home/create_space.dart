import 'package:flutter/material.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/spaces_model/spaces_model.dart';
import 'package:link_on/screens/spaces/spaces_home/main_space.dart';
import 'package:link_on/screens/spaces/spaces_home/widgets/space_material_button.dart';
import 'package:link_on/screens/spaces/spaces_provider/spaces_provider.dart';
import 'package:provider/provider.dart';

class CreateSpaceScreen extends StatefulWidget {
  const CreateSpaceScreen({
    super.key,
  });

  @override
  State<CreateSpaceScreen> createState() => _CreateSpaceScreenState();
}

class _CreateSpaceScreenState extends State<CreateSpaceScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isSwitchedPaidField = true;
  String selectedPrivacy = 'public'; // Adjusted to match the key from the JSON
  List<String> privacies = [
    'public', // Adjusted
    'social', // Adjusted
  ];
  final _formKey = GlobalKey<FormState>();

  Future<SpaceModel?> createSpace() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final spaceProvider = Provider.of<SpaceProvider>(context, listen: false);
    SpaceModel? spaceData = await spaceProvider.createSpace(
      context: context,
      title: nameController.text,
      description: descriptionController.text,
      privacy: privacies.indexOf(selectedPrivacy),
      amount: amountController.text.isEmpty ? null : amountController.text,
    );
    Navigator.pop(context);
    return spaceData;
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'create_your_space').toString(), // Adjusted
          style: const TextStyle(fontSize: 17),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate(context, 'name').toString(), // Adjusted
                  style: const TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  giveDefaultBorder: true,
                  hinttext: translate(context, 'space_name_hint'), // Adjusted
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'required'); // Adjusted
                    }
                    return null;
                  },
                  controller: nameController,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  translate(context, 'privacy').toString(), // Adjusted
                  style: const TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPrivacy = privacies[index];
                            });
                          },
                          child: Container(
                            width: 70,
                            decoration: BoxDecoration(
                              color: selectedPrivacy == privacies[index]
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                translate(context, privacies[index])
                                    .toString(), // Adjusted
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    itemCount: privacies.length,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translate(context, 'is_this_paid_space')
                          .toString(), // Adjusted
                      style: const TextStyle(fontSize: 17),
                    ),
                    Switch(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: isSwitchedPaidField,
                      onChanged: (val) {
                        setState(() {
                          isSwitchedPaidField = val;
                        });
                      },
                    )
                  ],
                ),
                Visibility(
                  visible: isSwitchedPaidField,
                  child: Column(
                    children: [
                      CustomTextField(
                        keyboardType: TextInputType.number,
                        giveDefaultBorder: true,
                        hinttext: translate(
                            context, 'enter_ticket_amount'), // Adjusted
                        controller: amountController,
                        validator: (val) {
                          if ((val == null || val.isEmpty) &&
                              isSwitchedPaidField) {
                            return translate(
                                context, 'amount_is_required'); // Adjusted
                          }

                          final amount = double.tryParse(val!);
                          if (amount == null || amount <= 0) {
                            return translate(
                                context, 'enter_valid_amount'); // Adjusted
                          }

                          return null; // Valid input
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
                Text(
                  translate(context, 'description').toString(), // Adjusted
                  style: const TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hinttext: translate(context, 'give_description'), // Adjusted
                  controller: descriptionController,
                  giveDefaultBorder: true,
                  maxLines: 5,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'required'); // Adjusted
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: SpaceMaterialButton(
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          createSpace().then(
                            (value) {
                              value != null
                                  ? Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainSpaceScreen(
                                          spaceData: value,
                                          isAudience: false,
                                          channel:
                                              getUserData.value.firstName! +
                                                  getUserData.value.id!,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            },
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            translate(context, 'start_now')
                                .toString(), // Adjusted
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // TextButton(
                //   onPressed: () {},
                //   child: Text(
                //     translate(context, 'get_to_know_spaces').toString(),
                //   ), // Adjusted
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

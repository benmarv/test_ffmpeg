import 'package:flutter/material.dart';
import 'package:link_on/consts/routes.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FocusNode inputFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    );

    return Container(
      child: TextField(
        focusNode: inputFocusNode,
        readOnly: true,
        onTap: () async {
          await Navigator.pushNamed(context, AppRoutes.search);
          inputFocusNode.unfocus();
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          hintText: "Search",
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: IconButton(
            onPressed: () {},
            icon: Icon(
              LineIcons.search,
              color: Theme.of(context).primaryColor,
              size: 26,
            ),
          ),
          filled: true,
          enabledBorder: outlineBorder,
          border: outlineBorder,
        ),
        cursorColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

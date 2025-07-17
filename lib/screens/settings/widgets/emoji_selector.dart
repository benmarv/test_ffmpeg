import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

class EmojiSelector extends StatelessWidget {
  final ValueChanged<String>? onTap;

  const EmojiSelector({
    Key? key,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          _buildSelector(context, LineIcons.thumbs_up, "Yes"),
          const SizedBox(width: 15.0),
          _buildSelector(context, LineIcons.thumbs_down, "No"),
        ],
      ),
    );
  }

  Widget _buildSelector(
    BuildContext context,
    IconData icon,
    String value,
  ) {
    final color = Theme.of(context).colorScheme.onPrimary;
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
        ),
        onPressed: () => onTap!(value),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(width: 10.0),
            Text(
              value,
              style: TextStyle(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

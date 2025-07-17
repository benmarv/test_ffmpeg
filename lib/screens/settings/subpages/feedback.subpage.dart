
import 'package:flutter/material.dart';
import 'package:link_on/screens/settings/widgets/emoji_selector.dart';

class FeedbackSubpage extends StatefulWidget {
  final String? title;
  final String? content;

  const FeedbackSubpage({
    Key? key,
    this.title,
    this.content,
  }) : super(key: key);
  @override
  _FeedbackSubpageState createState() => _FeedbackSubpageState();
}

class _FeedbackSubpageState extends State<FeedbackSubpage> {
  bool showThanks = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 15.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title!.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(widget.content!.toString()),
          const Divider(
            height: 36.0,
          ),
          _buildReaction(),
        ],
      ),
    );
  }

  Widget _buildReaction() {
    final emojiSelector = Visibility(
      visible: !showThanks,
      child: Container(
        child: EmojiSelector(
          onTap: (String value) {
            setState(() {
              showThanks = true;
            });
          },
        ),
      ),
    );

    final thankYouNote = Visibility(
      visible: showThanks,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.withOpacity(0.1)),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text("Thank you for your feedback")
          ],
        ),
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: !showThanks,
            child: const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text("Is your problem resolved?"),
            ),
          ),
          emojiSelector,
          thankYouNote,
        ],
      ),
    );
  }
}

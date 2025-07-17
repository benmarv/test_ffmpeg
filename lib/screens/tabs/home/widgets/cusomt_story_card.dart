import 'package:flutter/material.dart';

class CustomStoryCard extends StatelessWidget {
  const CustomStoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildEmptyStoriesList(context);
  }

  Widget _buildEmptyStoriesList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return _buildStoryItem(context);
      },
    );
  }

  Widget _buildStoryItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          _buildStoryContainer(context),
          _buildCircleAvatar(),
        ],
      ),
    );
  }

  Widget _buildStoryContainer(BuildContext context) {
    return Container(
      height: 150,
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      ),
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4, left: 3, right: 3),
        child: FittedBox(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade400.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            height: 15,
            width: 70,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleAvatar() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CircleAvatar(
        radius: 13.0,
        backgroundColor: Colors.grey.shade400.withOpacity(0.2),
      ),
    );
  }
}

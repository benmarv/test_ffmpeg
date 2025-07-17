import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';

class SpaceTicket extends StatelessWidget {
  final String ticketAmount;
  const SpaceTicket({
    super.key,
    required this.ticketAmount,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 25,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          '\$$ticketAmount',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

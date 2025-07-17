import 'package:flutter/material.dart';
import 'package:link_on/components/spaces_widgets/space_ticket.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/spaces_model/spaces_model.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/utils/utils.dart';

class CustomRoomTiles extends StatefulWidget {
  final SpaceModel? spacesData;
  final int? index;
  final Member? hostData;
  final bool? isSearchScreen;

  const CustomRoomTiles({
    Key? key,
    this.spacesData,
    this.index,
    this.isSearchScreen,
    this.hostData,
  }) : super(key: key);

  @override
  State<CustomRoomTiles> createState() => _CustomRoomTilesState();
}

class _CustomRoomTilesState extends State<CustomRoomTiles> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xff20283b),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLiveRow(),
          _buildTitleAndTicket(),
          5.sh,
          _buildDescription(),
          15.sh,
          _buildHostRow(),
        ],
      ),
    );
  }

  Widget _buildLiveRow() {
    return Row(
      children: [
        Utils.live(40.0),
        3.sw,
        Text(
          translate(context, 'live').toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  Widget _buildTitleAndTicket() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.7,
          child: Text(
            widget.spacesData!.title.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        if (widget.spacesData!.amount != '0')
          SpaceTicket(ticketAmount: widget.spacesData!.amount),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.spacesData!.description.toString(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }

  Widget _buildHostRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10.0, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 17.5,
                backgroundImage:
                    NetworkImage(widget.hostData!.avatar.toString()),
              ),
              8.sw,
              Text(
                "${widget.hostData!.firstName} ${widget.hostData!.lastName}",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              5.sw,
              const Icon(
                Icons.mic,
                color: AppColors.primaryColor,
                size: 15,
              ),
            ],
          ),
          15.sh,
          Row(
            children: [
              const Icon(Icons.hearing,
                  size: 13, color: AppColors.primaryColor),
              const SizedBox(width: 6),
              Text(
                '${widget.spacesData!.listenersCount} ${translate(context, 'listeners')}',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ],
          ),
          8.sh,
        ],
      ),
    );
  }
}

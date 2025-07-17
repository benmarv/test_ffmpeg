import 'package:flutter/material.dart';
import 'package:link_on/components/flutter_polls.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/models/posts.dart' as post_model;
import 'package:provider/provider.dart';

class PollPost extends StatelessWidget {
  const PollPost({super.key, this.posts, this.index, this.pollWidget});
  final post_model.Posts? posts;
  final int? index;
  final Widget? pollWidget;

  @override
  Widget build(BuildContext context) {
    return posts!.sharedPost != null
        ? Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Column(
                  children: [
                    pollWidget!,
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlutterPolls(
                          hasVoted: posts!.sharedPost!.poll!.isVoted == '1'
                              ? true
                              : false,
                          pollEnded: posts!.sharedPost!.poll!.isActive == '0'
                              ? true
                              : false,
                          userVotedOptionId:
                              posts!.sharedPost!.poll!.userVotedId,
                          pollTitle: posts!.sharedPost!.poll!.pollTitle == null
                              ? ''
                              : posts!.sharedPost!.poll!.pollTitle.toString(),
                          pollId: posts!.sharedPost!.pollId,
                          pollOptions: List.generate(
                            posts!.sharedPost!.poll!.pollOptions.length,
                            (index) => PollOption(
                              id: posts!
                                  .sharedPost!.poll!.pollOptions[index].id,
                              title: Text(
                                posts!.sharedPost!.poll!.pollOptions[index]
                                    .optionText!,
                                style: const TextStyle(color: Colors.white),
                              ),
                              votes: posts!.sharedPost!.poll!.pollOptions[index]
                                  .noOfVotes!,
                            ),
                          ),
                          onVoted: (PollOption pollOption, int newTotalVotes) {
                            return Provider.of<PostProvider>(context,
                                    listen: false)
                                .votePoll(
                                    pollOptionId: pollOption.id,
                                    pollId: posts!.sharedPost!.poll!.id);
                          },
                          votedCheckmark: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 14,
                          ),
                          pollOptionsFillColor:
                              AppColors.primaryColor.withOpacity(0.8),
                          leadingVotedProgessColor: AppColors.primaryColor,
                          pollOptionsBorder:
                              Border.all(color: Colors.grey.withOpacity(0.2)),
                          pollOptionsSplashColor: Colors.white,
                          voteInProgressColor:
                              Colors.grey[700]!.withOpacity(0.5),
                          votedProgressColor:
                              Colors.grey[700]!.withOpacity(0.3),
                          votedBackgroundColor: Colors.grey.withOpacity(0.6),
                          votedPercentageTextStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          votedPollOptionsBorder:
                              Border.all(color: Colors.grey.withOpacity(0.2)),
                        ))
                  ],
                ),
              ),
            ),
          )
        : FlutterPolls(
            pollTitle: posts!.poll!.pollTitle == null
                ? ''
                : posts!.poll!.pollTitle.toString(),
            pollId: posts!.pollId,
            hasVoted: posts!.poll!.isVoted == '1',
            userVotedOptionId: posts!.poll!.userVotedId,
            pollEnded: posts!.poll!.isActive == '0' ? true : false,
            pollOptions: List.generate(
              posts!.poll!.pollOptions.length,
              (index) => PollOption(
                id: posts!.poll!.pollOptions[index].id,
                title: Text(
                  posts!.poll!.pollOptions[index].optionText!,
                  style: const TextStyle(color: Colors.white),
                ),
                votes: posts!.poll!.pollOptions[index].noOfVotes!,
              ),
            ),
            onVoted: (PollOption pollOption, int newTotalVotes) {
              return Provider.of<PostProvider>(context, listen: false).votePoll(
                  pollOptionId: pollOption.id, pollId: posts!.poll!.id);
            },
            votedCheckmark: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 14,
            ),
            pollOptionsFillColor: AppColors.primaryColor.withOpacity(0.8),
            leadingVotedProgessColor: AppColors.primaryColor,
            pollOptionsBorder: Border.all(color: Colors.grey.withOpacity(0.2)),
            pollOptionsSplashColor: Colors.white,
            voteInProgressColor: Colors.grey[700]!.withOpacity(0.5),
            votedProgressColor: Colors.grey[700]!.withOpacity(0.3),
            votedBackgroundColor: Colors.grey.withOpacity(0.6),
            votedPercentageTextStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            votedPollOptionsBorder:
                Border.all(color: Colors.grey.withOpacity(0.2)),
          );
  }
}

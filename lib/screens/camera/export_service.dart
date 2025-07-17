import 'dart:io';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/statistics.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_editor/video_editor.dart';

@pragma('vm:entry-point')
class ExportService {
  static Future<void> dispose() async {
    final executions = await FFmpegKit.listSessions();
    if (executions.isNotEmpty) await FFmpegKit.cancel();
  }

  static Future<FFmpegSession> runFFmpegCommand(
      FFmpegVideoEditorExecute execute,
      {required void Function(File file) onCompleted,
      void Function(Object, StackTrace)? onError,
      void Function(Statistics)? onProgress}) {
    log('FFmpeg start process with command = ${execute.command}');
    String commadPart1 = execute.command.splitBefore('-y');
    String commadPart2 = execute.command.splitAfter('-y');

    String fullCommand =
        "$commadPart1-c:v libx264 -crf 18 -preset veryfast -c:a copy $commadPart2";
    log('full FFmpeg command = $fullCommand');

    return FFmpegKit.executeAsync(
      fullCommand,
      (session) async {
        try {
          final state =
              FFmpegKitConfig.sessionStateToString(await session.getState());

          final code = await session.getReturnCode();

          if (ReturnCode.isSuccess(code)) {
            onCompleted(File(execute.outputPath));
          } else {
            if (onError != null) {
              onError(
                Exception(
                    'FFmpeg process exited with state $state and return code $code.\n${await session.getOutput()}'),
                StackTrace.current,
              );
            }
            return;
          }
          print('FFmpeg session ID: ${session.getSessionId()}');
        } catch (e, stackTrace) {
          print('$e $stackTrace');
        }
        await session.cancel();
      },
      null,
      onProgress,
    );
  }
}

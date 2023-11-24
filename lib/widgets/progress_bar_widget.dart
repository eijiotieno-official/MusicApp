import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/services/my_audio_handler.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class ProgressBarWidget extends StatelessWidget {
  final MyAudioHandler audioHandler;
  final MediaItem item;
  const ProgressBarWidget(
      {super.key, required this.audioHandler, required this.item});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: AudioService.position,
      builder: (context, positionSnapshot) {
        if (positionSnapshot.data != null) {
          return ProgressBar(
            progress: positionSnapshot.data!,
            total: item.duration!,
            onSeek: (position) {
              audioHandler.seek(position);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

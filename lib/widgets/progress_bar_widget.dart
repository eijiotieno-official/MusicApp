// Import necessary Flutter packages
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

// Import your custom audio handler service
import 'package:musicapp/services/my_audio_handler.dart';

// ProgressBarWidget class, a StatelessWidget representing the progress bar for audio playback
class ProgressBarWidget extends StatelessWidget {
  // Constructor to initialize with a MediaItem and MyAudioHandler
  const ProgressBarWidget({
    super.key,
    required this.item,
    required this.audioHandler,
  });

  // MediaItem representing the current playing item
  final MediaItem item;

  // MyAudioHandler for managing audio playback
  final MyAudioHandler audioHandler;

  // build method, returns the widget tree for the ProgressBarWidget
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      // StreamBuilder to rebuild the UI when the playback position changes
      stream: AudioService.position,
      builder: (context, positionSnapshot) {
        if (positionSnapshot.data != null) {
          // ProgressBar widget to display the progress of audio playback
          return ProgressBar(
            progress: positionSnapshot.data!, // Current playback position
            total: item.duration!, // Total duration of the audio track
            timeLabelLocation:
                TimeLabelLocation.below, // Set the location of time labels
            onSeek: (positionOffset) {
              audioHandler
                  .seek(positionOffset); // Seek to the specified position
            },
          );
        } else {
          // Return an empty SizedBox if no playback position data is available
          return const SizedBox.shrink();
        }
      },
    );
  }
}

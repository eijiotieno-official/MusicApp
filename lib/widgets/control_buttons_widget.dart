// Import necessary Flutter packages
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

// Import your custom audio handler service
import 'package:musicapp/services/my_audio_handler.dart';

// ControlButtonsWidget class, a StatelessWidget representing playback control buttons
class ControlButtonsWidget extends StatelessWidget {
  // Constructor to initialize with a MediaItem and MyAudioHandler
  const ControlButtonsWidget({
    super.key,
    required this.item,
    required this.audioHandler,
  });

  // MediaItem representing the current playing item
  final MediaItem item;

  // MyAudioHandler for managing audio playback
  final MyAudioHandler audioHandler;

  // build method, returns the widget tree for the ControlButtonsWidget
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      // StreamBuilder to rebuild the UI when the playback state changes
      stream: audioHandler.playbackState.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          bool playing = snapshot.data!.playing;

          // Row containing playback control buttons
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Button to skip to the previous track
              IconButton.filledTonal(
                onPressed: () {
                  audioHandler.skipToPrevious();
                },
                icon: const Icon(
                  Icons.skip_previous_rounded,
                ),
              ),

              // Play/Pause button
              IconButton(
                onPressed: () {
                  if (playing) {
                    audioHandler.pause();
                  } else {
                    audioHandler.play();
                  }
                },
                icon: playing
                    ? const Icon(Icons.pause_rounded, size: 75)
                    : const Icon(Icons.play_arrow_rounded, size: 75),
              ),

              // Button to skip to the next track
              IconButton.filledTonal(
                onPressed: () {
                  audioHandler.skipToNext();
                },
                icon: const Icon(
                  Icons.skip_next_rounded,
                ),
              ),
            ],
          );
        }
        // Return an empty SizedBox if no playback state is available
        return const SizedBox.shrink();
      },
    );
  }
}

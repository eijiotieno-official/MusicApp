import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/services/my_audio_handler.dart';

class ControlButtonsWidget extends StatelessWidget {
  final MyAudioHandler audioHandler;
  final MediaItem item;
  const ControlButtonsWidget(
      {super.key, required this.audioHandler, required this.item});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: audioHandler.playbackState.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          bool playing = snapshot.data!.playing;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Skip to previous track
              IconButton.filledTonal(
                onPressed: () {
                  audioHandler.skipToPrevious();
                },
                icon: const Icon(
                  Icons.skip_previous_rounded,
                ),
              ),
              //Play and Pause
              IconButton(
                onPressed: () {
                  if (playing) {
                    audioHandler.pause();
                  } else {
                    audioHandler.play();
                  }
                },
                icon: playing
                    ? const Icon(
                        Icons.pause_rounded,
                        size: 75,
                      )
                    : const Icon(
                        Icons.play_arrow_rounded,
                        size: 75,
                      ),
              ), // Skip to next track
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
        return const SizedBox.shrink();
      },
    );
  }
}

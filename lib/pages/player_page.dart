// Import necessary Flutter packages
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

// Import your custom services and widgets
import 'package:musicapp/services/my_audio_handler.dart';
import 'package:musicapp/widgets/control_buttons_widget.dart';
import 'package:musicapp/widgets/cover_widget.dart';
import 'package:musicapp/widgets/progress_bar_widget.dart';

// PlayerPage class, a StatefulWidget representing the player screen of the app
class PlayerPage extends StatefulWidget {
  // Constructor to initialize with an instance of MyAudioHandler
  const PlayerPage({
    super.key,
    required this.audioHandler,
  });

  // Instance of MyAudioHandler for managing audio playback
  final MyAudioHandler audioHandler;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

// _PlayerPageState class, the corresponding State class for PlayerPage
class _PlayerPageState extends State<PlayerPage> {
  // build method, returns the widget tree for the PlayerPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Player"), // Set the title of the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        // StreamBuilder to rebuild the UI when the media item changes
        child: StreamBuilder<MediaItem?>(
          stream: widget.audioHandler.mediaItem,
          builder: (context, mediaSnapshot) {
            if (mediaSnapshot.data != null) {
              MediaItem item = mediaSnapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // CoverWidget to display the cover image
                  CoverWidget(item: item, audioHandler: widget.audioHandler),
                  Column(
                    children: [
                      // Song title
                      Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 20),
                      ),
                      // Artist name
                      Text(
                        item.artist!,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  // ProgressBarWidget to display the playback progress
                  ProgressBarWidget(
                      item: item, audioHandler: widget.audioHandler),
                  // ControlButtonsWidget for playback control buttons
                  ControlButtonsWidget(
                      item: item, audioHandler: widget.audioHandler),
                ],
              );
            }
            // Return an empty SizedBox if no media item is available
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

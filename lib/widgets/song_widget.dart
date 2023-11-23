// Import necessary Dart packages
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

// Import your custom pages and services
import 'package:musicapp/pages/player_page.dart';
import 'package:musicapp/services/fetch_songs.dart';
import 'package:musicapp/services/my_audio_handler.dart';

// SongWidget class, a StatelessWidget representing a song item in the list
class SongWidget extends StatelessWidget {
  // Constructor to initialize with a MyAudioHandler, MediaItem, and index
  const SongWidget({
    super.key,
    required this.item,
    required this.index,
    required this.audioHandler,
  });

  // MyAudioHandler for managing audio playback
  final MyAudioHandler audioHandler;

  // MediaItem representing the current song
  final MediaItem item;

  // Index of the song in the list
  final int index;

  // build method, returns the widget tree for the SongWidget
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      // StreamBuilder to rebuild the UI when the current media item changes
      stream: audioHandler.mediaItem,
      builder: (context, itemSnapshot) {
        return DecoratedBox(
          // Apply background color based on whether the song is currently playing
          decoration: BoxDecoration(
            color: audioHandler.mediaItem.value == item
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
          ),
          // ListTile to display the song information
          child: ListTile(
            // Leading widget, displaying the song's cover or a placeholder
            leading: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: item.artUri == null
                  ? const Icon(Icons.music_note)
                  : FutureBuilder<Uint8List?>(
                      // FutureBuilder to asynchronously load the cover image
                      future: toImage(uri: item.artUri!),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          // If the image is successfully loaded, display it using FadeInImage
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage(
                              fadeInDuration: const Duration(milliseconds: 800),
                              placeholder: MemoryImage(kTransparentImage),
                              image: MemoryImage(snapshot.data!),
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        // Return an empty SizedBox if the image is not available
                        return const SizedBox.shrink();
                      },
                    ),
            ),
            // onTap event to navigate to the PlayerPage when the song is tapped
            onTap: () {
              if (audioHandler.mediaItem.value != item) {
                audioHandler.skipToQueueItem(index);
              }

              Get.to(
                () => PlayerPage(
                  audioHandler: audioHandler,
                ),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 700),
              );
            },
            // Title and subtitle to display the song title and artist
            title: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(item.artist!),
          ),
        );
      },
    );
  }
}

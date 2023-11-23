// Import necessary Dart packages
import 'dart:typed_data';

// Import necessary Flutter packages
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/services/fetch_songs.dart';
import 'package:transparent_image/transparent_image.dart';

// Import your custom services
import 'package:musicapp/services/my_audio_handler.dart';

// CoverWidget class, a StatelessWidget representing the cover image of the currently playing song
class CoverWidget extends StatelessWidget {
  // Constructor to initialize with a MediaItem and MyAudioHandler
  const CoverWidget({
    super.key,
    required this.item,
    required this.audioHandler,
  });

  // MediaItem representing the current playing item
  final MediaItem item;

  // MyAudioHandler for managing audio playback
  final MyAudioHandler audioHandler;

  // build method, returns the widget tree for the CoverWidget
  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the size of the container based on the screen width
      height: MediaQuery.of(context).size.width * 0.7,
      width: MediaQuery.of(context).size.width * 0.7,
      // Decorate the container with rounded corners and a specified color
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      // Conditional rendering based on the availability of the artUri
      child: item.artUri == null
          ? const Icon(Icons
              .music_note) // Display a music note icon if artUri is not available
          : FutureBuilder<Uint8List?>(
              // FutureBuilder to asynchronously load the cover image from the artUri
              future: toImage(uri: item.artUri!),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  // If the image is successfully loaded, display it using FadeInImage
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      fadeInDuration: const Duration(milliseconds: 500),
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
    );
  }
}

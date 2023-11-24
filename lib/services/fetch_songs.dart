// import necessary Dart packages

import 'dart:convert';
import 'dart:typed_data';

// import packages from external dependencies

import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

// Create an instance of OnAudioQuery for querying audio information
OnAudioQuery onAudioQuery = OnAudioQuery();

// Function to request and check storage permission

Future<void> accessStorage() async =>
    await Permission.storage.status.isGranted.then(
      (granted) async {
        if (granted == false) {
          // request  storage permission and open app settings if denied permanently

          PermissionStatus permissionStatus =
              await Permission.storage.request();
          if (permissionStatus == PermissionStatus.permanentlyDenied) {
            await openAppSettings();
          }
        }
      },
    );

// Function to retrieve artwork for a given song ID
Future<Uint8List?> art({required int id}) async {
  return await onAudioQuery.queryArtwork(id, ArtworkType.AUDIO, quality: 100);
}

// Function to convert a Uri to an imge (Uint8List)
Future<Uint8List?> toImage({required Uri uri}) async {
  return base64.decode(uri.data!.toString().split(',').last);
}

// class to fetch songs and convert them to MediaItem format
class FetchSongs {
  // static method to execute fetching songs asynchronously
  static Future<List<MediaItem>> execute() async {
    // Initialize an empty list to store MediaItems
    List<MediaItem> items = [];

    // Ensure storage permission is granted before proceeding
    await accessStorage().then(
      (_) async {
        // Query songs using OnAudioQuery
        List<SongModel> songs = await onAudioQuery.querySongs();

        // loop through the retrieved songs and convert them to MediaItem
        for (SongModel song in songs) {
          if (song.isMusic == true) {
            // Retrieve artwork for the song
            Uint8List? uint8list = await art(id: song.id);
            List<int> bytes = [];
            if (uint8list != null) {
              bytes = uint8list.toList();
            }

            // add the converted song to the list of MediaItems
            items.add(
              MediaItem(
                id: song.uri!,
                title: song.title,
                artist: song.artist,
                duration: Duration(milliseconds: song.duration!),
                artUri: uint8list == null ? null : Uri.dataFromBytes(bytes),
              ),
            );
          }
        }
      },
    );
    return items;
  }
}

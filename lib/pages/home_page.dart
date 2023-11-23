// Import necessary Flutter packages
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

// Import your custom services and widgets
import 'package:musicapp/services/fetch_songs.dart';
import 'package:musicapp/services/my_audio_handler.dart';
import 'package:musicapp/widgets/song_widget.dart';

// HomePage class, a StatefulWidget representing the main screen of the app
class HomePage extends StatefulWidget {
  // Constructor to initialize with an instance of MyAudioHandler
  const HomePage({super.key, required this.audioHandler});

  // Instance of MyAudioHandler for managing audio playback
  final MyAudioHandler audioHandler;

  @override
  State<HomePage> createState() => _HomePageState();
}

// _HomePageState class, the corresponding State class for HomePage
class _HomePageState extends State<HomePage> {
  // List to store MediaItems representing songs
  List<MediaItem> songs = [];

  // initState method, called when the State is initialized
  @override
  void initState() {
    // Execute FetchSongs to retrieve and set the list of songs
    FetchSongs.execute().then(
      (value) {
        setState(() {
          songs = value;
        });
        // Initialize songs in the audio handler
        widget.audioHandler.initSongs(songs: value);
      },
    );
    super.initState();
  }

  // build method, returns the widget tree for the HomePage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music App"), // Set the title of the app bar
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(), // Set the scroll physics
        itemCount: songs.length, // Set the number of items in the list
        itemBuilder: (context, index) {
          MediaItem item = songs[index];
          // Build SongWidget for each song in the list
          return SongWidget(
            item: item,
            index: index,
            audioHandler: widget.audioHandler,
          );
        },
      ),
    );
  }
}

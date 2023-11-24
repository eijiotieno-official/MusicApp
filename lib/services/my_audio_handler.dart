// import necessary packages

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

// MyAudioHandler class that extends BaseAudioHandler with QueueHandler and SeekHandler

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  //create an instance of the AudioPlayer class from just_audio package
  AudioPlayer audioPlayer = AudioPlayer();

  // Function to create an audio source from a MediaItem

  UriAudioSource _createAudioSource(MediaItem item) {
    return ProgressiveAudioSource(Uri.parse(item.id));
  }

  // Listen for changes in the current song index and update the media item
  void _listenForCurrentSongIndexChanges() {
    audioPlayer.currentIndexStream.listen(
      (index) {
        final playlist = queue.value;
        if (index == null || playlist.isEmpty) return;
        mediaItem.add(playlist[index]);
      },
    );
  }

  // Broadcast the current playback state based on the received PlaybackEvent

  void _broadcastState(PlaybackEvent event) {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (audioPlayer.playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[audioPlayer.processingState]!,
        playing: audioPlayer.playing,
        updatePosition: audioPlayer.position,
        bufferedPosition: audioPlayer.bufferedPosition,
        speed: audioPlayer.speed,
        queueIndex: event.currentIndex,
      ),
    );
  }

  // Function to initialize the songs and set up the audio player
  Future<void> initSongs({required List<MediaItem> songs}) async {
    // Listen for playback events and broadcast the state
    audioPlayer.playbackEventStream.listen(_broadcastState);

    // create a list of audio sources from the provided songs
    final audioSource = songs.map(_createAudioSource);

    // set the audio source of the audio player to the concatenation of the audio sources
    await audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: audioSource.toList()));

    // Add the songs to the queue
    final newQueue = queue.value..addAll(songs);
    queue.add(newQueue);

    // listen for changes in the current song index
    _listenForCurrentSongIndexChanges();

    // listen for processing state changes, and skip to the next song when completed
    audioPlayer.processingStateStream.listen(
      (state) {
        if (state == ProcessingState.completed) skipToNext();
      },
    );
  }

  // Play function to start playback
  @override
  Future<void> play() async => audioPlayer.play();

  // Pause function to pause playback
  @override
  Future<void> pause() async => audioPlayer.pause();

  // seek function to change the playback position
  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  // skip to a specific item in the queue and start playback
  @override
  Future<void> skipToQueueItem(int index) async {
    await audioPlayer.seek(Duration.zero, index: index);
    play();
  }

  // skip to next item in the queue
  @override
  Future<void> skipToNext() async => audioPlayer.seekToNext();

  // skip to previous item in the queue
  @override
  Future<void> skipToPrevious() async => audioPlayer.seekToPrevious();
}

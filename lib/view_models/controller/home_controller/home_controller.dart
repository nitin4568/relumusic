import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:placementt/data/repository/homepage_repository/home_page_repo.dart';
import 'package:placementt/models/home_models/track_models.dart';

class HomeController extends GetxController {

  final ApiService _apiService = ApiService();
  final AudioPlayer audioPlayer = AudioPlayer();

  var tracks = <TrackModel>[].obs;
  var isLoading = false.obs;
  var currentlyPlayingId = 0.obs;

  var isPlaying = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;

  int offset = 0;
  final int limit = 25;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchTracks();
    _initAudioListeners();
  }

  void _initAudioListeners() {

    audioPlayer.onDurationChanged.listen((duration) {
      totalDuration.value = duration;
    });

    audioPlayer.onPositionChanged.listen((position) {
      currentPosition.value = position;
    });

    audioPlayer.onPlayerComplete.listen((event) {
      isPlaying.value = false;
      currentlyPlayingId.value = 0;
      currentPosition.value = Duration.zero;
    });
  }

  Future<void> fetchTracks() async {

    if (isLoading.value || !hasMore) return;

    try {
      isLoading.value = true;

      final data = await _apiService.fetchTracks(offset);

      if (data.isEmpty) {
        hasMore = false;
      } else {
        tracks.addAll(
          data.map((e) => TrackModel.fromJson(e)).toList(),
        );
        offset += limit;
      }

    } finally {
      isLoading.value = false;
    }
  }

  Future<void> playPause(TrackModel track) async {

    if (track.previewUrl == null || track.previewUrl!.isEmpty) {
      Get.snackbar("Error", "Preview not available");
      return;
    }

    if (currentlyPlayingId.value == track.id) {

      if (isPlaying.value) {
        await audioPlayer.pause(); // 🔥 pause
        isPlaying.value = false;
      } else {
        await audioPlayer.resume(); // 🔥 resume
        isPlaying.value = true;
      }

    } else {

      await audioPlayer.stop();
      await audioPlayer.play(
        UrlSource(track.previewUrl!),
      );

      currentlyPlayingId.value = track.id;
      isPlaying.value = true;
    }
  }

  Future<void> seek(double seconds) async {
    await audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  String formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:placementt/data/repository/homepage_repository/home_page_repo.dart';
import 'package:placementt/models/home_models/track_models.dart';

class DetailsViewModel extends GetxController {

  final ApiService _apiService = ApiService();
  final AudioPlayer audioPlayer = AudioPlayer();

  var track = Rxn<TrackModel>();
  var lyrics = ''.obs;
  var isLoading = true.obs;
  var error = ''.obs;

  var isPlaying = false.obs;

  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();

    track.value = Get.arguments as TrackModel;

    _initAudioListeners();
    loadLyrics();
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
      currentPosition.value = Duration.zero;
    });
  }

  Future<void> loadLyrics() async {
    try {
      lyrics.value = await _apiService.fetchLyrics(
        track.value!.title,
        track.value!.artist,
      );
    } catch (e) {
      error.value = "Lyrics not available";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> playPause() async {

    if (track.value?.previewUrl == null ||
        track.value!.previewUrl!.isEmpty) {
      Get.snackbar("Error", "Preview not available");
      return;
    }

    if (isPlaying.value) {
      await audioPlayer.pause(); // 🔥 pause (not stop)
      isPlaying.value = false;
    } else {
      if (currentPosition.value > Duration.zero) {
        await audioPlayer.resume(); // 🔥 resume from pause
      } else {
        await audioPlayer.play(
          UrlSource(track.value!.previewUrl!),
        );
      }
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
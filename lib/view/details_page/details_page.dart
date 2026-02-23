import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placementt/view_models/controller/details_controller/details_controller.dart';

class DetailsScreen extends StatelessWidget {

  final DetailsViewModel controller =
  Get.find<DetailsViewModel>();

  DetailsScreen({super.key});

  String formatDuration(int? seconds) {
    if (seconds == null) return "--:--";
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return "$minutes:${remaining.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Now Playing"),
      ),

      body: Obx(() {

        final track = controller.track.value;

        if (track == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // 🎵 Artwork
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  track.artwork ?? '',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 30),

              // 🎵 Title
              Text(
                track.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // 🎵 Artist
              Text(
                track.artist,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
// 🔥 Audio Progress Section
              Obx(() {

                final current = controller.currentPosition.value;
                final total = controller.totalDuration.value;

                return Column(
                  children: [

                    Slider(
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey,
                      min: 0,
                      max: total.inSeconds.toDouble() == 0
                          ? 1
                          : total.inSeconds.toDouble(),
                      value: current.inSeconds.toDouble().clamp(
                          0,
                          total.inSeconds.toDouble() == 0
                              ? 1
                              : total.inSeconds.toDouble()),
                      onChanged: (value) {
                        controller.seek(value);
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.formatTime(current),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          controller.formatTime(total),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 6),

              // 🎵 Album
              Text(
                track.album ?? "",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 6),

              // 🎵 Duration
              Text(
                "Duration: ${formatDuration(track.duration)}",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 30),

              // 🎵 BIG Play Button (Spotify Style)
              Obx(() => IconButton(
                iconSize: 70,
                icon: Icon(
                  controller.isPlaying.value
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  color: Colors.green,
                ),
                onPressed: controller.playPause,
              )),

              const SizedBox(height: 30),

              const Divider(color: Colors.grey),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Lyrics",
                  style: TextStyle(
                    color: Colors.green[400],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : Text(
                controller.lyrics.value.isEmpty
                    ? "Lyrics not available"
                    : controller.lyrics.value,
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.6,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
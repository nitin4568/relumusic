import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placementt/resource/routes/routs.dart';
import 'package:placementt/view_models/controller/home_controller/home_controller.dart';

class HomeScreen extends StatelessWidget {

  final HomeController controller = Get.find<HomeController>();
  final ScrollController scrollController = ScrollController();

  HomeScreen({super.key}) {

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.fetchTracks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Music Library"),
        backgroundColor: Colors.black,
      ),

      body: Obx(() {

        if (controller.isLoading.value &&
            controller.tracks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: controller.tracks.length +
              (controller.isLoading.value ? 1 : 0),
          itemBuilder: (context, index) {

            if (index < controller.tracks.length) {

              final track = controller.tracks[index];

              return Column(
                children: [

                  // 🔥 MAIN TILE
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        track.artwork ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),

                    title: Text(
                      track.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    subtitle: Text(
                      track.artist,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    onTap: () {
                      Get.toNamed(
                        AppRouteNames.details,
                        arguments: track,
                      );
                    },

                    trailing: Obx(() {

                      bool isCurrent =
                          controller.currentlyPlayingId.value == track.id;

                      return IconButton(
                        icon: Icon(
                          isCurrent && controller.isPlaying.value
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          color: Colors.green,
                          size: 32,
                        ),
                        onPressed: () {
                          controller.playPause(track);
                        },
                      );
                    }),
                  ),

                  // 🔥 MINI AUDIO TRACKER
                  Obx(() {

                    bool isCurrent =
                        controller.currentlyPlayingId.value == track.id;

                    if (!isCurrent) return const SizedBox();

                    final current =
                        controller.currentPosition.value;
                    final total =
                        controller.totalDuration.value;

                    return Column(
                      children: [

                        Slider(
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                          min: 0,
                          max: total.inSeconds == 0
                              ? 1
                              : total.inSeconds.toDouble(),
                          value: current.inSeconds
                              .toDouble()
                              .clamp(
                              0,
                              total.inSeconds == 0
                                  ? 1
                                  : total.inSeconds
                                  .toDouble()),
                          onChanged: (value) {
                            controller.seek(value);
                          },
                        ),

                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.formatTime(current),
                                style: const TextStyle(
                                    color: Colors.white70),
                              ),
                              Text(
                                controller.formatTime(total),
                                style: const TextStyle(
                                    color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              );

            } else {

              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        );
      }),
    );
  }
}
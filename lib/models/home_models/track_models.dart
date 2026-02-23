class TrackModel {
  final int id;
  final String title;
  final String artist;
  final String? artwork;
  final String? previewUrl;
  final String? album;
  final int? duration; // seconds

  TrackModel({
    required this.id,
    required this.title,
    required this.artist,
    this.artwork,
    this.previewUrl,
    this.album,
    this.duration,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['trackId'],
      title: json['trackName'] ?? '',
      artist: json['artistName'] ?? '',
      artwork: json['artworkUrl100'],
      previewUrl: json['previewUrl'],
      album: json['collectionName'],
      duration: json['trackTimeMillis'] != null
          ? (json['trackTimeMillis'] / 1000).round()
          : null,
    );
  }
}
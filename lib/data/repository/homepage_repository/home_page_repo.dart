import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<dynamic>> fetchTracks(int offset) async {

    final url =
        "https://itunes.apple.com/search?term=eminem&entity=song&limit=25&offset=$offset";

    print("API URL: $url");

    final response = await http.get(Uri.parse(url));

    print("STATUS CODE: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("DATA LENGTH: ${data['results'].length}");
      return data['results'];
    } else {
      throw Exception("Failed");
    }
  }
  // 🔹 Fetch Lyrics (LRCLIB)
  Future<String> fetchLyrics(String title, String artist) async {

    final url =
        "https://lrclib.net/api/get-cached?track_name=$title&artist_name=$artist";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['plainLyrics'] ?? "Lyrics not available";
    } else {
      return "Lyrics not available";
    }
  }
}
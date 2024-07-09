import 'package:spotify/spotify.dart' as spotify;

class Track {
  final String name;
  final List<Artist> artists;
  final Album album;
  final String previewUrl;

  Track({
    required this.name,
    required this.artists,
    required this.album,
    required this.previewUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      name: json['name'] ?? '',
      artists: (json['artists'] as List<dynamic>)
          .map((artist) => Artist.fromJson(artist))
          .toList(),
      album: Album.fromJson(json['album']),
      previewUrl: json['preview_url'] ?? '',
    );
  }
}

class Artist {
  final String name;

  Artist({required this.name});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'] ?? '',
    );
  }
}

class Album {
  final String name;
  final List<String> availableMarkets;
  final List<Image> images;

  Album({
    required this.name,
    required this.availableMarkets,
    required this.images,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'] ?? '',
      availableMarkets:
          List<String>.from(json['available_markets'] ?? []),
      images: (json['images'] as List<dynamic>)
          .map((image) => Image.fromJson(image))
          .toList(),
    );
  }
}

class Image {
  final String url;
  final int width;
  final int height;

  Image({
    required this.url,
    required this.width,
    required this.height,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}

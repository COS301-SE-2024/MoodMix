class Playlist {
  final String name;
  final String description;
  final int songCount;
  final String link;

  Playlist({
    required this.name,
    required this.description,
    required this.songCount,
    required this.link,
  });

  factory Playlist.fromMap(Map<String, dynamic> data) {
    return Playlist(
      name: data['UserPlaylist_Name'] ?? 'Unknown Name',
      description: data['UserPlaylist_Description'] ?? 'Unknown Description',
      songCount: data['UserPlaylist_SongCount'] ?? 'Unknown Song Count',
      link: data['UserPlaylist_Link'] ?? 'Unknown Link',
    );
  }
}

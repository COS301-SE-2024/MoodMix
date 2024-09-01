import 'package:flutter/material.dart';

class SongRibbon extends StatelessWidget {
  final String songName;
  final String artistName;
  final String imageUrl;

  const SongRibbon({
    Key? key,
    required this.songName,
    required this.artistName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.9,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded( // Added Expanded to allow for flexible space usage
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  songName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  overflow: TextOverflow.ellipsis, // Truncate text with ellipsis
                  maxLines: 1, // Ensure text doesn't overflow more than one line
                ),
                Text(
                  artistName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  ),
                  overflow: TextOverflow.ellipsis, // Optional: handle artist name overflow similarly
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const express = require('express');
const axios = require('axios');
const dotenv = require('dotenv');
const SpotifyWebApi = require('spotify-web-api-node');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 42069;

// Spotify credentials from .env file
const spotifyApi = new SpotifyWebApi({
  clientId: process.env.SPOTIFY_CLIENT,
  clientSecret: process.env.SPOTIFY_CLIENT_SECRET,
  redirectUri: process.env.REDIRECT_URI

});

const scopes = [
  'ugc-image-upload',
  'user-read-playback-state',
  'user-modify-playback-state',
  'user-read-currently-playing',
  'streaming',
  'app-remote-control',
  'user-read-email',
  'user-read-private',
  'playlist-read-collaborative',
  'playlist-modify-public',
  'playlist-read-private',
  'playlist-modify-private',
  'user-library-modify',
  'user-library-read',
  'user-top-read',
  'user-read-playback-position',
  'user-read-recently-played',
  'user-follow-read',
  'user-follow-modify'
];



app.get('/login', (req, res) => {
  res.redirect(spotifyApi.createAuthorizeURL(scopes));
});

app.get('/callback', (req, res) => {
  const error = req.query.error;
  const code = req.query.code;
  const state = req.query.state;

  if (error) {
    console.error('Callback Error:', error);
    res.send(`Callback Error: ${error}`);
    return;
  }

  spotifyApi
    .authorizationCodeGrant(code)
    .then(data => {
      const access_token = data.body['access_token'];
      const refresh_token = data.body['refresh_token'];
      const expires_in = data.body['expires_in'];

      spotifyApi.setAccessToken(access_token);
      spotifyApi.setRefreshToken(refresh_token);

      console.log('access_token:', access_token);
      console.log('refresh_token:', refresh_token);

      console.log(
        `Sucessfully retreived access token. Expires in ${expires_in} s.`
      );
      res.send('Success! You can now close the window.');

      setInterval(async () => {
        const data = await spotifyApi.refreshAccessToken();
        const access_token = data.body['access_token'];

        console.log('The access token has been refreshed!');
        console.log('access_token:', access_token);
        spotifyApi.setAccessToken(access_token);
      }, expires_in / 2 * 1000);
    })
    .catch(error => {
      console.error('Error getting Tokens:', error);
      res.send(`Error getting Tokens: ${error}`);
    });
});
// Route for fetching user ID
app.get('/getUserInfo', async (req, res) => {
  try {
    console.log('getUserInfo');
    // Retrieve user information (including user ID)
    const data = await spotifyApi.getMe();
    console.log("Data from the spotify api", data.body);
    const userId = data.body.id;

    res.json({ userId });
  } catch (error) {
    res.status(400).json({ error: 'Error fetching user info' });
  }
});

// Route for creating a playlist
app.post('/createPlaylist', async (req, res) => {
  try {
    const userId = '21p9n1j4k3s6l4pkxmqzhlnkv'; // Replace with your Spotify user ID
    const playlistName = 'Capstone testing';

    // Create playlist
    const data = await spotifyApi.createPlaylist(userId, playlistName, { public: true });
    const playlistId = data.body.id;

    res.json({ playlistId });
  } catch (error) {
    res.status(400).json({ error: 'Error creating playlist' });
  }
});

// Route for getting playlists from a user
app.get('/getPlaylists', async (req, res) => {
  try {
    // Get current user's playlists
    const data = await spotifyApi.getUserPlaylists();
    const playlists = data.body.items;

    res.json({ playlists });
  } catch (error) {
    res.status(400).json({ error: 'Error getting playlists' });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});

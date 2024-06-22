const express = require('express');
const axios = require('axios');
const dotenv = require('dotenv');
const SpotifyWebApi = require('spotify-web-api-node');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5001;

// Spotify credentials from .env file
const spotifyApi = new SpotifyWebApi({
  clientId: process.env.SPOTIFY_CLIENT_ID,
  clientSecret: process.env.SPOTIFY_CLIENT_SECRET,
  redirectUri: process.env.REDIRECT_URI,
});

// Example routes
app.get('/login', function(req, res) {

  var state = generateRandomString(16);
  var scope = 'user-read-private user-read-email';

  res.redirect('https://accounts.spotify.com/authorize?' +
    querystring.stringify({
      response_type: 'code',
      client_id: '21p9n1j4k3s6l4pkxmqzhlnkv',
      scope: scope,
      redirect_uri: redirect_uri,
      state: state
    }));
});

app.get('/callback', async (req, res) => {
  const code = req.query.code || null;
  
  try {
    // Retrieve access token and refresh token
    const data = await spotifyApi.authorizationCodeGrant(code);
    const { access_token, refresh_token } = data.body;

    // Set access token for further Spotify API calls
    spotifyApi.setAccessToken(access_token);
    spotifyApi.setRefreshToken(refresh_token);

    res.json({ access_token, refresh_token });
  } catch (error) {
    res.status(400).json({ error: 'Error retrieving tokens' });
  }
});

// Route for fetching user ID
app.get('/getUserInfo', async (req, res) => {
  try {
    // Retrieve user information (including user ID)
    const data = await spotifyApi.getMe();
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

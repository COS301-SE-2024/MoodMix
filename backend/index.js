var express = require('express');
var axios = require('axios');
var crypto = require('crypto');
var cors = require('cors');
var querystring = require('querystring');
var cookieParser = require('cookie-parser');
require('dotenv').config();

var client_id = process.env.SPOTIFY_CLIENT; // your clientId
var client_secret = process.env.SPOTIFY_CLIENT_SECRET; // Your secret
var redirect_uri = process.env.REDIRECT_URI; // Your redirect uri
var stateKey = 'spotify_auth_state';
var accessToken = null;
var refreshToken = null;
var userDetails = {};

const generateRandomString = (length) => {
  return crypto
    .randomBytes(60)
    .toString('hex')
    .slice(0, length);
}

// Function to fetch user details and store them in the userDetails object
function fetchUserDetails(token, callback) {
  var options = {
    method: 'get',
    url: 'https://api.spotify.com/v1/me',
    headers: { 'Authorization': 'Bearer ' + token },
  };

  axios(options)
    .then(response => {
      if (response.status === 200) {
        userDetails = response.data;
        console.log('User details fetched and stored:');
        if (callback) callback();
      } else {
        console.error('Failed to fetch user details:', response.status, response.data);
      }
    })
    .catch(error => {
      console.error('Failed to fetch user details:', error.response.status, error.response.data);
    });
}

var app = express();

app.use(express.static(__dirname + '/public'))
  .use(cors())
  .use(cookieParser());

app.get('/login', function (req, res) {
  var state = generateRandomString(16);
  res.cookie(stateKey, state);

  var scope = 'user-read-private user-read-email playlist-read-collaborative playlist-modify-public';
  res.redirect('https://accounts.spotify.com/authorize?' +
    querystring.stringify({
      response_type: 'code',
      client_id: client_id,
      scope: scope,
      redirect_uri: redirect_uri,
      state: state
    }));
});

app.get('/callback', function (req, res) {
  var code = req.query.code || null;
  var state = req.query.state || null;
  var storedState = req.cookies ? req.cookies[stateKey] : null;

  if (state === null || state !== storedState) {
    res.redirect('http://127.0.0.1:5001/#/welcome' +
      querystring.stringify({
        error: 'state_mismatch'
      }));
  } else {
    res.clearCookie(stateKey);
    var authOptions = {
      method: 'post',
      url: 'https://accounts.spotify.com/api/token',
      data: querystring.stringify({
        code: code,
        redirect_uri: redirect_uri,
        grant_type: 'authorization_code'
      }),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' + (Buffer.from(client_id + ':' + client_secret).toString('base64'))
      }
    };

    axios(authOptions)
      .then(response => {
        if (response.status === 200) {
          var access_token = response.data.access_token;
          var refresh_token = response.data.refresh_token;

          accessToken = access_token;
          refreshToken = refresh_token;

          fetchUserDetails(access_token, function () {
            res.redirect('http://localhost:5001/#/welcome' +
              querystring.stringify({
                access_token: access_token,
                refresh_token: refresh_token
              }));
          });
        } else {
          res.redirect('http://127.0.0.1:5001/#/welcome' +
            querystring.stringify({
              error: 'invalid_token'
            }));
        }
      })
      .catch(error => {
        res.redirect('http://127.0.0.1:5001/#/welcome' +
          querystring.stringify({
            error: 'invalid_token'
          }));
      });
  }
});

// Example route to use the stored access token
app.get('/spotify-user', function (req, res) {
  if (!userDetails) {
    return res.status(401).send('User details are not available');
  }
  console.log('User details:', userDetails);
  res.json(userDetails);
});

// Get user's playlists
app.get('/spotify-playlists', function (req, res) {
  if (!accessToken) {
    return res.status(401).send('Access token is not available');
  }

  var options = {
    method: 'get',
    url: 'https://api.spotify.com/v1/me/playlists',
    headers: { 'Authorization': 'Bearer ' + accessToken },
  };

  axios(options)
    .then(response => {
      if (response.status === 200) {
        console.log('Playlists fetched:', response.data);
        res.json(response.data);
      } else {
        res.status(response.status).send(response.data);
      }
    })
    .catch(error => {
      res.status(error.response.status).send(error.response.data);
    });
});

// Create a new playlist
app.get('/spotify-create-playlist', function (req, res) {
  if (!accessToken) {
    return res.status(401).send('Access token is not available');
  }

  var name = req.query.name || 'Bananna';
  var description = req.query.description || 'And calculator';

  var user_id = userDetails.id;

  var playlistOptions = {
    method: 'post',
    url: `https://api.spotify.com/v1/users/${user_id}/playlists`,
    headers: {
      'Authorization': 'Bearer ' + accessToken,
      'Content-Type': 'application/json'
    },
    data: {
      'name': name,
      'description': description,
      'public': true
    }
  };

  axios(playlistOptions)
    .then(response => {
      if (response.status === 201) {
        var playlist_id = response.data.id;

        var track_uris = ['spotify:track:4iV5W9uYEdYUVa79Axb7Rh', 'spotify:track:1301WleyT98MSxVHPZCA6M'];

        var addTracksOptions = {
          method: 'post',
          url: `https://api.spotify.com/v1/playlists/${playlist_id}/tracks`,
          headers: {
            'Authorization': 'Bearer ' + accessToken,
            'Content-Type': 'application/json'
          },
          data: {
            'uris': track_uris
          }
        };

        axios(addTracksOptions)
          .then(resp => {
            if (resp.status === 201) {
              res.json(resp.data);
            } else {
              res.status(resp.status).send(resp.data);
            }
          })
          .catch(err => {
            res.status(err.response.status).send(err.response.data);
          });
      } else {
        res.status(response.status).send(response.data);
      }
    })
    .catch(error => {
      res.status(error.response.status).send(error.response.data);
    });
});

app.listen(5002, function () {
  console.log('Listening on 5002');
  console.log('http://localhost:5002/login');
  console.log('http://localhost:5002/spotify-user');
  console.log('http://localhost:5002/spotify-playlists');
  console.log('http://localhost:5002/spotify-create-playlist');
});

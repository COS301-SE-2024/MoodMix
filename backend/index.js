var express = require('express');
var request = require('request');
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
    url: 'https://api.spotify.com/v1/me',
    headers: { 'Authorization': 'Bearer ' + token },
    json: true
  };

  request.get(options, function (error, response, body) {
    if (!error && response.statusCode === 200) {
      userDetails = body;
      console.log('User details fetched and stored:');
      if (callback) callback();
    } else {
      console.error('Failed to fetch user details:', response.statusCode, body);
    }
  });
}



var app = express();

app.use(express.static(__dirname + '/public'))
  .use(cors())
  .use(cookieParser());

app.get('/login', function (req, res) {

  var state = generateRandomString(16);
  res.cookie(stateKey, state);


  // your application requests authorization
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

  // your application requests refresh and access tokens
  // after checking the state parameter
  console.log('callback');

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
      url: 'https://accounts.spotify.com/api/token',
      form: {
        code: code,
        redirect_uri: redirect_uri,
        grant_type: 'authorization_code'
      },
      headers: {
        'content-type': 'application/x-www-form-urlencoded',
        Authorization: 'Basic ' + (new Buffer.from(client_id + ':' + client_secret).toString('base64'))
      },
      json: true
    };

    request.post(authOptions, function (error, response, body) {
      if (!error && response.statusCode === 200) {

        var access_token = body.access_token,
          refresh_token = body.refresh_token;

        accessToken = access_token;
        refreshToken = refresh_token;

        fetchUserDetails(access_token, function () {
          // Redirect back to Flutter app with the tokens
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
    url: 'https://api.spotify.com/v1/me/playlists',
    headers: { 'Authorization': 'Bearer ' + accessToken },
    json: true
  };

  request.get(options, function (error, response, body) {
    if (!error && response.statusCode === 200) {
      console.log('Playlists fetched:', body)
      res.json(body);
    } else {
      res.status(response.statusCode).send(body);
    }
  });
});

// Create a new playlist
app.get('/spotify-create-playlist', function (req, res) {
  if (!accessToken) {
    return res.status(401).send('Access token is not available');
  }

  var user_id = userDetails.id; // Get user ID from stored details

  var playlistOptions = {
    url: `https://api.spotify.com/v1/users/${user_id}/playlists`,
    headers: {
      'Authorization': 'Bearer ' + accessToken,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      name: 'New Playlist', // Replace with desired playlist name
      description:'New playlist description', // Replace with desired playlist description
      public: true // Set to true if you want the playlist to be public
    }),
    json: true
  };

  request.post(playlistOptions, function (error, response, body) {
    if (!error && response.statusCode === 201) {
      res.json(body);
    } else {
      res.status(response.statusCode).send(body);
    }
  });
});







app.listen(5002, function () {
  console.log('Listening on 5002');
  console.log('http://localhost:5002/login');
  console.log('http://localhost:5002/callback');
  console.log('http://localhost:5002/spotify-user');
  console.log('http://localhost:5002/spotify-playlists');
  console.log('http://localhost:5002/spotify-create-playlist');
});
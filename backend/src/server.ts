import express from 'express';
import bodyParser from 'body-parser';
import dotenv from 'dotenv';
import spotifyRoutes from './spotify/spotifyRoutes';

dotenv.config();

const app = express();
app.use(bodyParser.json());

const PORT = process.env.PORT || 3000;

app.use('/api/spotify', spotifyRoutes);

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

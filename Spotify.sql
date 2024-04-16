use Spotify;

--Count the number of songs in the dataset
SELECT COUNT(*) AS TotalSongs
FROM dbo.spotifydata;

--Count the number of songs in the dataset
SELECT AVG(CAST(duration_ms AS decimal)) AS AverageDuration
FROM spotifydata;

--Calculate the maximum and minimum popularity of songs:
SELECT
  (SELECT MAX(popularity) FROM spotifydata) AS MaxPopularity,
  (SELECT MIN(popularity) FROM spotifydata) AS MinPopularity,
  (SELECT TOP 1 name FROM spotifydata WHERE popularity = (SELECT MAX(popularity) FROM spotifydata)) AS MostPopularSong,
  (SELECT TOP 1 name FROM spotifydata WHERE popularity = (SELECT MIN(popularity) FROM spotifydata)) AS LeastPopularSong;

--Group songs by year and count the number of songs released in each year
SELECT year, COUNT(*) AS NumSongs
FROM spotifydata
GROUP BY year
ORDER BY year ;

--Calculate the average danceability and energy of songs:
SELECT AVG(danceability) AS AverageDanceability, AVG(energy) AS AverageEnergy
FROM spotifydata;

--Find the top 10 most popular artists based on their average popularity:
SELECT TOP 10 artists, AVG(popularity) AS AveragePopularity
FROM spotifydata
GROUP BY artists
ORDER BY AveragePopularity DESC;

--Get the total duration of songs for each artist:
SELECT artists, SUM(duration_ms) AS TotalDuration
FROM spotifydata
GROUP BY artists;

--Retrieve the top 10 songs along with their artists and the year they were released:
SELECT TOP 10 s.name AS SongName, s.artists, s.year
FROM spotifydata AS s
ORDER BY s.popularity DESC

--converting duration into int and handle nulls by filling it with unknown
UPDATE dbo.spotifydata
SET duration_ms = CAST(duration_ms AS INT),
    artists = COALESCE(artists, 'Unknown');

SELECT 
  name,
  artists,
  popularity,
  AVG(popularity) OVER (PARTITION BY artists) AS avg_artist_popularity
FROM spotifydata;

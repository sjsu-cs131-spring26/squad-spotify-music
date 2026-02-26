# Data Card

## Source
- **Dataset:** Spotify 1.2M+ Songs
- **Link:** https://www.kaggle.com/datasets/rodolfofigueroa/spotify-12m-songs
- **File:** tracks_features.csv
- **Format:** CSV (uncompressed)

## Size & Shape
- **Rows:** 1,204,026
- **Columns:** 24
- **File size:** 330MB

## Columns & Delimiter
- **Delimiter:** comma (,)
- **Header:** present on row 1
- **Encoding:** UTF-8

### Column List:
id, name, album, album_id, artists, artist_ids, track_number, disc_number, explicit, danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo, duration_ms, time_signature, year, release_date

## Data Quality Notes
- `artists` and `artist_ids` columns contain lists formatted as `"['artist1', 'artist2']"` with embedded commas — requires special parsing (awk/grep instead of cut)
- Some tracks have multiple artists which inflates artist counts
- `explicit` is a boolean (True/False string)
- `year` and `release_date` are separate columns (year is integer, release_date is YYYY-MM-DD)

# Dataset Download Instructions

## Spotify 1.2M+ Songs Dataset

**Source:** https://www.kaggle.com/datasets/rodolfofigueroa/spotify-12m-songs

### How to Download via Kaggle API:
1. Install the Kaggle CLI: `pip3 install kaggle --user`
2. Get your API key from https://www.kaggle.com/settings → Legacy API Credentials → Create New Token
3. Place `kaggle.json` in `~/.kaggle/` and run `chmod 600 ~/.kaggle/kaggle.json`
4. Run the following commands:
```bash
export PATH=$PATH:~/.local/bin
mkdir -p ~/data
cd ~/data
kaggle datasets download -d rodolfofigueroa/spotify-12m-songs
unzip spotify-12m-songs.zip
```

### Expected Files:
- `tracks_features.csv` - Main dataset with 1.2M+ Spotify tracks

### Dataset Features:
- Track name, artist, album (string columns)
- Audio features: tempo, energy, danceability, acousticness, etc. (numerical)
- Explicit flag, track ID, URI
- Release date information

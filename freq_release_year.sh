#!/usr/bin/env bash
# =============================================================================
# freq_release_year.sh — Frequency table for release year
#
# Dataset : tracks_features.csv  (rodolfofigueroa Spotify 1.2M Songs)
# Columns : id(1), name(2), popularity(3), duration_ms(4), explicit(5),
#           artists(6), id_artists(7), release_date(8), danceability(9),
#           energy(10), key(11), loudness(12), mode(13), speechiness(14),
#           acousticness(15), instrumentalness(16), liveness(17), valence(18),
#           tempo(19), time_signature(20)
# Delimiter: comma (,)
# Column   : 8 = release_date (format: YYYY, YYYY-MM, or YYYY-MM-DD)
#            We extract just the 4-digit year using cut -c1-4
# Output   : out/freq_release_year.txt
# Usage    : bash freq_release_year.sh [path/to/tracks_features.csv]
# =============================================================================

DATASET="${1:-tracks_features.csv}"
OUTDIR="out"
OUTFILE="${OUTDIR}/freq_release_year.txt"

mkdir -p "$OUTDIR"

if [[ ! -f "$DATASET" ]]; then
    echo "ERROR: Dataset not found at '$DATASET'" >&2
    echo "Usage: bash freq_release_year.sh [path/to/tracks_features.csv]" >&2
    exit 1
fi

echo "Building release year frequency table from: $DATASET"
echo "Output -> $OUTFILE"

# Header
echo -e "count\trelease_year" > "$OUTFILE"

# Skip header row, extract col 8 (release_date), take first 4 chars = year,
# filter out any non-year values with grep, count & sort descending
tail -n +2 "$DATASET" \
    | cut -d',' -f8 \
    | cut -c1-4 \
    | grep -E '^[0-9]{4}$' \
    | sort \
    | uniq -c \
    | sort -nr \
    | awk '{print $1"\t"$2}' \
    | tee -a "$OUTFILE"

echo ""
echo "Done. $(( $(wc -l < "$OUTFILE") - 1 )) unique years found."
echo "Full table saved to $OUTFILE"

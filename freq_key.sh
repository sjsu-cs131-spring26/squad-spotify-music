#!/usr/bin/env bash
# =============================================================================
# freq_key.sh — Frequency table for musical key (col 11)
#
# Dataset : tracks_features.csv  (rodolfofigueroa Spotify 1.2M Songs)
# Columns : id(1), name(2), popularity(3), duration_ms(4), explicit(5),
#           artists(6), id_artists(7), release_date(8), danceability(9),
#           energy(10), key(11), loudness(12), mode(13), speechiness(14),
#           acousticness(15), instrumentalness(16), liveness(17), valence(18),
#           tempo(19), time_signature(20)
# Delimiter: comma (,)
# Column   : 11 = key (integer 0-11, pitch class; -1 = unknown)
# Output   : out/freq_key.txt
# Usage    : bash freq_key.sh [path/to/tracks_features.csv]
# =============================================================================

DATASET="${1:-tracks_features.csv}"
OUTDIR="out"
OUTFILE="${OUTDIR}/freq_key.txt"

# Map integer keys to note names
declare -A KEY_NAMES=(
    [0]="C" [1]="C#/Db" [2]="D" [3]="D#/Eb"
    [4]="E" [5]="F"     [6]="F#/Gb" [7]="G"
    [8]="G#/Ab" [9]="A" [10]="A#/Bb" [11]="B"
)

mkdir -p "$OUTDIR"

if [[ ! -f "$DATASET" ]]; then
    echo "ERROR: Dataset not found at '$DATASET'" >&2
    echo "Usage: bash freq_key.sh [path/to/dataset.csv]" >&2
    exit 1
fi

echo "Building musical key frequency table from: $DATASET"
echo "Output -> $OUTFILE"

# Print header
echo -e "count\tkey_id\tkey_name" > "$OUTFILE"

# Build raw counts first into a temp file, then enrich with key names
TMPFILE=$(mktemp)

tail -n +2 "$DATASET" \
    | cut -d',' -f11 \
    | sort \
    | uniq -c \
    | sort -nr \
    > "$TMPFILE"

# Enrich: append human-readable key name
while read -r count key_id; do
    key_name="${KEY_NAMES[$key_id]:-unknown}"
    echo -e "${count}\t${key_id}\t${key_name}" | tee -a "$OUTFILE"
done < "$TMPFILE"

rm -f "$TMPFILE"

echo ""
echo "Done. $(( $(wc -l < "$OUTFILE") - 1 )) unique keys found."
echo "Full table saved to $OUTFILE"

#!/usr/bin/env bash

DATASET="${1:-}"
DELIM="${2:-,}"

if [[ -z "$DATASET" ]]; then
  echo "Usage: $0 <dataset_path> <delimiter>" >&2
  exit 1
fi

OUTDIR="out/evidence"
LOGFILE="out/run_sprint3.log"
ERRFILE="out/errors.log"

mkdir -p "$OUTDIR" out

COL_TRACK_ID=2
COL_ARTISTS=3
COL_EXPLICIT=8
COL_GENRE=21

{
  echo "=== Sprint 3 Run Start ==="
  date
  echo "Dataset: $DATASET"
  echo

  awk -F"$DELIM" -v id="$COL_TRACK_ID" -v ar="$COL_ARTISTS" -v ex="$COL_EXPLICIT" -v ge="$COL_GENRE" '
  NR==1 {next}
  {
    if ($id=="") mid++
    if ($ar=="") mar++
    if ($ex=="") mex++
    if ($ge=="") mge++
    n++
  }
  END {
    print "rows=" n
    print "missing_track_id=" (mid+0)
    print "missing_artists=" (mar+0)
    print "missing_explicit=" (mex+0)
    print "missing_genre=" (mge+0)
  }
  ' "$DATASET" > "$OUTDIR/trust_missingness.txt"

  awk -F"$DELIM" -v c="$COL_TRACK_ID" 'NR>1{print $c}' "$DATASET" \
  | sort | uniq -d | wc -l > "$OUTDIR/assumption_duplicate_track_ids.txt"

  awk -F"$DELIM" -v c="$COL_ARTISTS" 'NR>1{print $c}' "$DATASET" \
  | sort | uniq -c | sort -nr | head -20 > "$OUTDIR/decision_top_artists.txt"

  awk -F"$DELIM" -v c="$COL_EXPLICIT" 'NR>1{print $c}' "$DATASET" \
  | sort | uniq -c | sort -nr > "$OUTDIR/decision_explicit_frequency.txt"

  awk -F"$DELIM" -v c="$COL_GENRE" 'NR>1{print $c}' "$DATASET" \
  | sort | uniq -c | sort -nr | head -20 > "$OUTDIR/decision_top_genres.txt"

  echo
  echo "=== Sprint 3 Run End ==="
  date
} 2> "$ERRFILE" | tee "$LOGFILE"

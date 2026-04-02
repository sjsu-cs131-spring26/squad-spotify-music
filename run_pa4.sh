#!/bin/bash
set -euo pipefail

# PA4 Entry Script
# Usage: bash run_pa4.sh <INPUT>
# Example: bash run_pa4.sh ~/data/tracks_features.csv

INPUT="$1"

mkdir -p out logs

chmod -R g+rX "$INPUT" 2>/dev/null || true

# Task 2: Quality filters
echo "Running Task 2: Quality filters..."
awk -F',' '
  NR==1 || (NF>=24 && $2!="" && $(NF-1)~/^[0-9]{4}$/ && $10+0>=0 && $10+0<=1.0)
' "$INPUT" | head -1001 > out/filtered_sample.tsv || true
echo "Done. Output: out/filtered_sample.tsv"

# Task 4: Temporal danceability analysis
echo "Running Task 4: Temporal danceability analysis..."
awk -F',' '
  NR==1{next}
  {year=$(NF-1); dance=$10;
   if(year~/^[0-9]{4}$/ && dance+0>0 && dance+0<=1.0)
     {sum[year]+=dance; count[year]++}}
  END{for(y in sum) printf "%s\t%d\t%.3f\n", y, count[y], sum[y]/count[y]}
' "$INPUT" | sort -k1,1n > out/year_danceability.tsv
echo "Done. Output: out/year_danceability.tsv"

echo "All tasks complete."

#!/bin/bash
set -euo pipefail

# PA4 Entry Script
# Usage: bash run_pa4.sh <INPUT>
# Example: bash run_pa4.sh ~/data/tracks_features.csv

INPUT="$1"

mkdir -p out logs

chmod -R g+rX "$INPUT" 2>/dev/null || true

LOG="logs/run_pa4.log"
echo "Starting PA4 run at $(date)" | tee "$LOG"
echo "Dataset: $INPUT" | tee -a "$LOG"

# Task 1: Clean and normalize with SED
echo "Running Task 1: SED clean and normalize..." | tee -a "$LOG"
head -6 "$INPUT" > out/before_sample.tsv
head -6 "$INPUT" | sed -E "s/\[([^]]+)\]/\1/g" > out/after_sample.tsv
echo "Done. Outputs: out/before_sample.tsv, out/after_sample.tsv" | tee -a "$LOG"

# Task 2: Quality filters
echo "Running Task 2: Quality filters..." | tee -a "$LOG"
awk -F',' '
  NR==1 || (NF>=24 && $2!="" && $(NF-1)~/^[0-9]{4}$/ && $10+0>=0 && $10+0<=1.0)
' "$INPUT" | head -1001 > out/filtered_sample.tsv || true
echo "Done. Output: out/filtered_sample.tsv" | tee -a "$LOG"

# Task 3: Ratios, buckets, per-entity summaries
echo "Running Task 3: Explicit rate by year with buckets..." | tee -a "$LOG"
awk -F',' '
  NR==1{next}
  {
    year=$(NF-1); explicit=$9;
    if(year~/^[0-9]{4}$/) {
      total[year]++;
      if(explicit=="True") expl[year]++
    }
  }
  END{
    for(y in total) {
      rate = (total[y]>0) ? expl[y]/total[y] : 0;
      if(rate==0) bucket="ZERO";
      else if(rate<0.05) bucket="LO";
      else if(rate<0.15) bucket="MID";
      else bucket="HI";
      printf "%s\t%d\t%d\t%.3f\t%s\n", y, total[y], expl[y]+0, rate, bucket
    }
  }
' "$INPUT" | sort -k1,1n > out/explicit_rate_by_year.tsv
echo "Done. Output: out/explicit_rate_by_year.tsv" | tee -a "$LOG"

# Task 4: Temporal danceability analysis
echo "Running Task 4: Temporal danceability analysis..." | tee -a "$LOG"
awk -F',' '
  NR==1{next}
  {year=$(NF-1); dance=$10;
   if(year~/^[0-9]{4}$/ && dance+0>0 && dance+0<=1.0)
     {sum[year]+=dance; count[year]++}}
  END{for(y in sum) printf "%s\t%d\t%.3f\n", y, count[y], sum[y]/count[y]}
' "$INPUT" | sort -k1,1n > out/year_danceability.tsv
echo "Done. Output: out/year_danceability.tsv" | tee -a "$LOG"

# Task 5: Signal discovery - distribution profile of audio features
echo "Running Task 5: Audio feature signal discovery..." | tee -a "$LOG"
awk -F',' '
  NR==1{next}
  {
    dance=$10; energy=$(NF-9); valence=$(NF-7);
    if(dance+0>0 && dance+0<=1.0 && energy+0>0 && energy+0<=1.0 && valence+0>=0 && valence+0<=1.0) {
      n++;
      sd+=dance; se+=energy; sv+=valence;
      if(n==1){mind=dance;maxd=dance;mine=energy;maxe=energy;minv=valence;maxv=valence}
      if(dance<mind)mind=dance; if(dance>maxd)maxd=dance;
      if(energy<mine)mine=energy; if(energy>maxe)maxe=energy;
      if(valence<minv)minv=valence; if(valence>maxv)maxv=valence;
    }
  }
  END{
    printf "feature\tcount\tmean\tmin\tmax\n";
    printf "danceability\t%d\t%.3f\t%.3f\t%.3f\n", n, sd/n, mind, maxd;
    printf "energy\t%d\t%.3f\t%.3f\t%.3f\n", n, se/n, mine, maxe;
    printf "valence\t%d\t%.3f\t%.3f\t%.3f\n", n, sv/n, minv, maxv;
  }
' "$INPUT" > out/audio_signals.tsv
echo "Done. Output: out/audio_signals.tsv" | tee -a "$LOG"



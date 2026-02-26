
#!/bin/bash
# run_project2.sh
# Usage: bash run_project2.sh
# Assumptions: dataset at ~/data/tracks_features.csv, delimiter is comma

DATA=~/data/tracks_features.csv
mkdir -p data/samples out

echo "Generating sample..."
head -1 $DATA > data/samples/sample_1k.csv
tail -n +2 $DATA | shuf -n 1000 >> data/samples/sample_1k.csv

echo "Building frequency tables..."
tail -n +2 $DATA | cut -d',' -f9 | sort | uniq -c | sort -nr > out/freq_explicit.txt
grep -oP '\d{4},\d{4}-\d{2}-\d{2}$' $DATA | cut -d',' -f1 | sort | uniq -c | sort -nr | head -20 > out/freq_year.txt

echo "Building Top-N artists..."
awk -F'"' 'NR>1 && NF>1{print $2}' $DATA | grep -oP "(?<=\[')[^']+" | sort | uniq -c | sort -nr | head -10 > out/topN_artists.txt

echo "Building skinny table..."
cut -d',' -f2,9,23 $DATA | sort -u | head -1000 > out/skinny_table.txt

echo "Running grep examples..."
grep -i "beatles" $DATA | cut -d',' -f2,23 | sort -u | tee out/beatles_tracks.txt > out/results.txt 2> out/errors.txt
grep -v ",True," $DATA | wc -l >> out/results.txt

echo "Done! Outputs in out/"

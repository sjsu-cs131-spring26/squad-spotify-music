#Set value of input data to first arg
DATA=$1
OUTFOLDER=$2
#Create small before sample
SAMPLESIZE=500
{ head -n1 "$DATA"; tail -n +2 "$DATA" | shuf | head -n$SAMPLESIZE; } > $OUTFOLDER/before_sample.csv

#Step 1, clean data
sed -E '/^[[:space:]]+/d; /[[:space:]]+$/d; s/[[:space:]]+/ /g' $DATA | sed -E "s/\['//g; s/'\]//g" | sed -E "s/(\.[0-9]{4})[0-9]*/\1/g" > $OUTFOLDER/temp_sample.csv

{ head -n1 "${OUTFOLDER}/temp_sample.csv"; tail -n +2 "${OUTFOLDER}/temp_sample.csv" | shuf | head -n$SAMPLESIZE; } > "${OUTFOLDER}/after_sample.csv"

touch "${OUTFOLDER}/explicit_ratio_buckets.txt"

#Step 3, Ratio of artist explicit songs to total songs 
#The awk begins by creating buckets, then iterates through the data. If a song is explicit, it adds to an explicit dictionary of the artist. It adds the song to another dictionary. Then it compares the ratio and places it in the appropriate bucket. 
awk -F',' 'BEGIN {zero=0; low=0; med=0; high=0;}
{if ($9 == "True") explicit[$5]++; songs[$5]++} END {for (a in songs){if (songs[a] > 0) ratio = explicit[a] / songs[a]; else ratio = 0; if (ratio > 0.75) high++; else if (ratio > 0.4) med++; else if (ratio > 0) low++; else zero++;} printf("Artists with: \nZero explicit language:%d\nLittle explicit language:%d\nMedium explicit language:%d\nHigh explicit language:%d", zero, low, med, high)}' "${OUTFOLDER}/temp_sample.csv" | tee "${OUTFOLDER}/explicit_ratio_buckets.txt"

rm "${OUTFOLDER}/temp_sample.csv"

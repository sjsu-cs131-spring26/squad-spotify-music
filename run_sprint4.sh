#Set value of input data to first arg
DATA=$1
OUTFOLDER=$2
#Create small before sample
SAMPLESIZE=500
{ head -n1 "$DATA"; tail -n +2 "$DATA" | shuf | head -n$SAMPLESIZE; } > $OUTFOLDER/before_sample.csv

#Step 1, clean data
sed -E '/^[[:space:]]+/d; /[[:space:]]+$/d; s/[[:space:]]+/ /g' $DATA | sed -E "s/\['//g; s/'\]//g" | sed -E "s/(\.[0-9]{4})[0-9]*/\1/g" > $OUTFOLDER/temp_sample.csv

{ head -n1 "${OUTFOLDER}/temp_sample.csv"; tail -n +2 "${OUTFOLDER}/temp_sample.csv" | shuf | head -n$SAMPLESIZE; } > "${OUTFOLDER}/after_sample.csv"

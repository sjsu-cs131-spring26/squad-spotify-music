from typing import cast
from pyspark.sql.functions import col, count, avg, round as spark_round
from pyspark.sql import SparkSession


spark = (
    SparkSession.builder
    .appName("Team9_Sec2_Sprint5")
    .master("local[*]")
    .config("spark.sql.shuffle.partitions", "8")
    .getOrCreate()
)



#Mostly intact code from notebook 
data = spark.read.csv("gs://spotify-tracks-dataset/tracks_features.csv", header=True, inferSchema=True, sep=",", quote='"', escape='"')

#-------Check the data is imported correctly 
print("--Data imported-- \nSchema:")
data.printSchema()

print("Data sample: ")
data.show(4)


#------Top 20 artists by amount of songs, plus their average energy and tempo
print("Top 20 artists by amount of songs, plus their average energy and tempo:")

top_artists = (
    data.select("artists", "energy", "tempo")
    .groupBy("artists")
    .agg(
        count("*").alias("count"),
        avg("energy").alias("avg_energy"),
        avg("tempo").alias("avg_tempo")
    )
    .orderBy("count", ascending=False)

)



top_artists.coalesce(1).limit(20).write.mode("overwrite").csv("gs://spotify-tracks-dataset/outputs/top-artists")
top_artists.show(20, truncate=False)


#-------Song count from 1990-2025
print("Song count from 1990-2025")

year_count = (
    data
    .withColumn("year_clean", col("year").cast("double").cast("int"))
    .filter((col("year_clean") >= 1950) & (col("year_clean") <= 2025))
    .groupBy("year_clean")
    .count()
    .orderBy("year_clean")
)

year_count.show(200)
year_count.coalesce(1).write.mode("overwrite").csv("gs://spotify-tracks-dataset/outputs/decade-songs")



#----Average Danceability, Energy, and Valence by Decade
yearly_features = (
    data.withColumn("decade", (data.year/10).cast("int")*10)
    .withColumn("danceability", col("danceability").cast("double"))
    .withColumn("energy",       col("energy").cast("double"))
    .withColumn("valence",      col("valence").cast("double"))
    .filter((col("decade") >= 1950) & (col("decade") <= 2020))
    .groupBy("decade")
    .agg(
        spark_round(avg("danceability"), 3).alias("avg_danceability"),
        spark_round(avg("energy"),       3).alias("avg_energy"),
        spark_round(avg("valence"),      3).alias("avg_valence")
    )
    .orderBy("decade")
)

yearly_features.show(20)
yearly_features.coalesce(1).limit(20).write.mode("overwrite").csv("gs://spotify-tracks-dataset/outputs/yearly-features")


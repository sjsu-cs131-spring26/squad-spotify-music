
---Data---
The data is placed in a Google Cloud bucket at the topmost layer. 

---RUNNING THE JOB---

The job is hosted on Google Cloud and uses Dataproc/Managed Apache Spark service to run. Therefore, the endpoints it references and imports are configured for Apache spark. 

To run it locally, change the paths to match the local data references and ensure that Pyspark is available on the machine. 

To run it in cloud, submit a Pyspark job using Google Cloud Apache Spark with this script as the submitted job. 
- All that is required is a cluster to be created and data to be held in a cloud storage bucket, with the approriate names so that the URL works 

---Results---

The outputs are placed as CSV files into the same Google Cloud bucket. Currently, a single bucket holds both the data and output, though in a larger project, additional buckets could be used and URLs specified to create more separation. 

The output bucket has a folder for each CSV graph created, as placing them all in the same would have each output overwrite each other. 

A copy of the outputs is also placed in the Github Repo under Cloud/Outputs
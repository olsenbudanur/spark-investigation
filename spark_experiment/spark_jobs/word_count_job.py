from pyspark.sql import SparkSession
import sys

def word_count(input_file, output_file):
    spark = SparkSession.builder.appName("WordCount").getOrCreate()

    # Read input file
    lines = spark.read.text(input_file).rdd.map(lambda r: r[0])

    # Split lines into words and count
    counts = lines.flatMap(lambda x: x.split(' ')) \
                  .map(lambda x: (x, 1)) \
                  .reduceByKey(lambda a, b: a + b)

    # Save the output
    counts.saveAsTextFile(output_file)

    spark.stop()

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: word_count_job.py <input_file> <output_file>")
        sys.exit(1)
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    word_count(input_file, output_file)

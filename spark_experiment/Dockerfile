FROM docker.io/apache/spark:3.5.0
USER root
RUN apt-get update && apt-get install -y python3 python3-pip
COPY spark_jobs/word_count_job.py /opt/spark/work-dir/
COPY spark_jobs/sample_input.txt /opt/spark/work-dir/
USER 185

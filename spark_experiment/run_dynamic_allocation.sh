#!/bin/bash

# Set up Spark configuration for dynamic allocation
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin

# Run the Spark job with dynamic allocation
$SPARK_HOME/bin/spark-submit \
    --master k8s://https://$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}'):6443 \
    --deploy-mode cluster \
    --name word-count-dynamic \
    --conf spark.kubernetes.container.image=spark-python:3.5.0-custom \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.dynamicAllocation.enabled=true \
    --conf spark.dynamicAllocation.shuffleTracking.enabled=true \
    --conf spark.dynamicAllocation.minExecutors=1 \
    --conf spark.dynamicAllocation.maxExecutors=5 \
    --conf spark.dynamicAllocation.initialExecutors=1 \
    --conf spark.executor.cores=1 \
    --conf spark.executor.memory=512m \
    local:///opt/spark/work-dir/word_count_job.py \
    /opt/spark/work-dir/sample_input.txt \
    /opt/spark/work-dir/output_dynamic

# Wait for the job to complete
kubectl wait --for=condition=completed pod -l spark-role=driver --timeout=300s

# Get the logs
kubectl logs $(kubectl get pods -l spark-role=driver -o name | tail -n 1)

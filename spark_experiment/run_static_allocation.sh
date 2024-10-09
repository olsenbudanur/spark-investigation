#!/bin/bash

# Set up Spark configuration for static allocation
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin

# Function to get resource usage
get_resource_usage() {
    echo "Resource usage at $(date):"
    kubectl top pods -l spark-app-selector=$1 --containers || echo "Failed to get resource usage"
    echo "------------------------"
}

# Run the Spark job with static allocation
JOB_NAME="word-count-static-$(date +%s)"
$SPARK_HOME/bin/spark-submit \
    --master k8s://https://$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}'):6443 \
    --deploy-mode cluster \
    --name $JOB_NAME \
    --conf spark.kubernetes.container.image=spark-python:3.5.0-custom \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.executor.instances=2 \
    --conf spark.executor.cores=1 \
    --conf spark.executor.memory=512m \
    --conf spark.dynamicAllocation.enabled=false \
    local:///opt/spark/work-dir/word_count_job.py \
    /opt/spark/work-dir/sample_input.txt \
    /opt/spark/work-dir/output_static &

# Get the Spark application ID
sleep 10
APP_ID=$(kubectl get pods -l spark-app-name=$JOB_NAME -o jsonpath='{.items[0].metadata.labels.spark-app-selector}')

# Collect resource usage every 10 seconds while the job is running
while kubectl get pods -l spark-app-selector=$APP_ID | grep -q Running; do
    get_resource_usage $APP_ID
    sleep 10
done

# Wait for the job to complete
kubectl wait --for=condition=completed pod -l spark-app-selector=$APP_ID --timeout=300s

# Get the logs
echo "Job logs:"
kubectl logs -l spark-app-selector=$APP_ID

# Final resource usage
get_resource_usage $APP_ID

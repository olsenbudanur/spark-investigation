# Investigation: Dynamic Allocation vs. Static Allocation in Apache Spark

## 1. Introduction

This document presents a detailed investigation into the efficiency of Apache Spark's dynamic resource allocation feature compared to static allocation. The primary goal was to determine if dynamic allocation could provide computational benefits for batch jobs with unknown loads, particularly in the context of auto-scaling.

## 2. Methodology

### 2.1 Environment Setup

- **Cluster Emulation**: We used Kind (Kubernetes in Docker) to emulate a local Spark cluster.
- **Spark Version**: Apache Spark 3.5.0
- **Kubernetes**: Used for orchestrating Spark on K8s
- **Docker**: Custom image `spark-python:3.5.0-custom` built for the experiments

### 2.2 Experiment Design

We conducted two main experiments:

1. **Static Allocation**: Fixed number of executors (2)
2. **Dynamic Allocation**: Starting with 1 executor, potentially scaling up to 5

Both experiments used a word count job as a representative batch processing task.

### 2.3 Metrics Collection

- Job Completion Time
- Number of Executors
- Resource Usage (limited due to Metrics Server issues)
- Reshuffling Events

### 2.4 Experiment Execution

1. Created custom Spark Docker image with necessary configurations
2. Set up Kind cluster and deployed Spark on Kubernetes
3. Ran static allocation experiment using `run_static_allocation.sh`
4. Ran dynamic allocation experiment using `run_dynamic_allocation.sh`
5. Collected logs and available metrics for analysis

## 3. Results

### 3.1 Static Allocation

- Job Completion Time: Approximately 22 seconds
- Number of Executors: 2 (fixed)
- Resource Usage: Unable to obtain accurate measurements
- Reshuffling Events: None observed

### 3.2 Dynamic Allocation

- Job Completion Time: Approximately 23 seconds
- Number of Executors: Started with 1, potentially scaled up to 5
- Resource Usage: Unable to obtain accurate measurements
- Reshuffling Events: None observed

## 4. Analysis

### 4.1 Job Completion Time

The static allocation experiment completed slightly faster (22 seconds) compared to the dynamic allocation experiment (23 seconds). However, this 1-second difference is minimal and may not be statistically significant.

### 4.2 Resource Utilization

Due to issues with the Metrics Server, we couldn't obtain accurate resource usage statistics. This limitation prevents us from drawing definitive conclusions about the resource efficiency of dynamic allocation compared to static allocation.

### 4.3 Scaling and Reshuffling

No explicit reshuffling events were observed in the logs for either experiment. This suggests that the workload may not have been large or complex enough to trigger significant executor scaling or data redistribution in the dynamic allocation scenario.

### 4.4 Configuration and Error Analysis

The dynamic allocation logs showed errors related to Python execution, which may have impacted its performance. This highlights the importance of proper configuration when using dynamic allocation.

## 5. Discussion

### 5.1 Efficiency of Dynamic Allocation

Based on the limited data available, we cannot conclusively state that dynamic allocation is less expensive computationally compared to static allocation for this particular workload. The similar job completion times suggest that, for small and simple tasks, the overhead of dynamic allocation might offset its potential benefits.

### 5.2 Potential Benefits for Unknown Loads

While our experiments didn't demonstrate significant advantages for dynamic allocation, it's important to note that the benefits may become more apparent with:
- Larger datasets
- More complex computations
- Workloads with varying resource requirements over time

### 5.3 Cost of Reshuffling

In our experiments, we did not observe any significant reshuffling events. This could be due to the small scale of our test or the nature of the word count task. For more complex jobs with multiple stages, the cost of reshuffling after scaling up executors could potentially impact performance.

## 6. Limitations and Future Work

### 6.1 Limitations

1. Small-scale experiment: The word count job may not have been complex enough to showcase the full potential of dynamic allocation.
2. Metrics collection issues: The lack of detailed resource usage data limited our ability to compare efficiency.
3. Configuration challenges: Errors in the dynamic allocation setup may have affected its performance.

### 6.2 Future Work

1. Conduct experiments with larger datasets and more complex computations.
2. Resolve Metrics Server issues to obtain accurate resource usage statistics.
3. Investigate and optimize dynamic allocation configurations.
4. Perform multiple iterations of each experiment for statistical significance.
5. Test with workloads that have varying resource requirements over time.

## 7. Conclusion

While our initial experiments did not show a clear advantage for dynamic allocation in terms of computational efficiency, they highlighted important considerations for its use. Dynamic allocation may be more beneficial for larger, more complex workloads with varying resource needs. Future investigations with improved metrics collection and a wider range of workloads will provide more comprehensive insights into the efficiency of Spark's dynamic allocation feature for batch jobs with unknown loads.

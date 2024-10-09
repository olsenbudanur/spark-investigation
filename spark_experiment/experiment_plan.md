# Spark Dynamic Allocation vs. Static Allocation Experiment Plan

## Objective
Compare the computational efficiency of Spark's dynamic allocation feature with static executor allocation for batch jobs with unknown loads, considering the cost of re-shuffling after scaling up executors.

## Experiment Setup
- Use Spark on Kubernetes with Kind to emulate a Spark cluster locally
- Implement sample batch jobs with varying computational and shuffle requirements
- Use Spark's built-in metrics and Kubernetes monitoring for data collection

## Experiments

1. Static Allocation Baseline
   - Run a set of Spark batch jobs with a fixed number of executors
   - Vary the workload size (small, medium, large)
   - Measure execution time, resource utilization, and shuffle performance

2. Dynamic Allocation
   - Run the same set of Spark batch jobs with dynamic allocation enabled
   - Use the same workload sizes as in the static allocation experiment
   - Measure execution time, resource utilization, scaling behavior, and shuffle performance

3. Reshuffling Impact
   - Design jobs that require significant data shuffling
   - Compare static vs. dynamic allocation for these shuffle-heavy jobs
   - Measure the impact of executor scaling on shuffle performance and overall job completion time

## Metrics to Collect
- Job completion time
- CPU utilization
- Memory utilization
- Number of executors used over time (for dynamic allocation)
- Shuffle read/write times
- Data spilled to disk during shuffles
- Time spent on executor allocation/deallocation (for dynamic allocation)

## Implementation Details
1. Create sample Spark batch jobs:
   - Word count job with varying input sizes
   - K-means clustering with different dataset sizes
   - PageRank algorithm with various graph sizes

2. Configure Spark for static allocation:
   - Set fixed number of executors
   - Adjust executor cores and memory

3. Configure Spark for dynamic allocation:
   - Enable dynamic allocation
   - Set minimum and maximum number of executors
   - Configure scale-up and scale-down behavior

4. Run experiments:
   - Execute each job type with both static and dynamic allocation
   - Repeat experiments with different input sizes to simulate unknown loads
   - Collect metrics for each run

5. Analyze results:
   - Compare execution times between static and dynamic allocation for each workload size
   - Evaluate resource utilization efficiency
   - Assess the impact of dynamic allocation on shuffle-heavy workloads
   - Determine scenarios where dynamic allocation provides better computational efficiency
   - Analyze the cost of re-shuffling after scaling up executors in dynamic allocation

## Expected Outcomes
- Quantify the difference in computational efficiency between static and dynamic allocation
- Identify workload characteristics that benefit most from dynamic allocation
- Assess the overhead of dynamic allocation, including reshuffling costs
- Provide recommendations for when to use dynamic allocation vs. static allocation based on job characteristics and cluster conditions

This experiment plan will help determine if Spark's dynamic allocation feature is less expensive computationally compared to hard-coding the number of executors, especially for batch jobs with unknown loads.

# Scenario: Performance Optimization

Use this for query or request performance, planning or cost decisions, hot
paths, contention, memory, or benchmark-driven work.

## Flow

1. Define the workload and success metric.
2. Establish a reproducible baseline before changing code.
3. Form one or more hypotheses.
4. Inspect plans, traces, profiles, counters, and relevant source.
5. Make the smallest change that tests the strongest hypothesis.
6. Verify correctness before measuring performance.
7. Compare against baseline with the same dataset and server options.
8. Review regression risk and affected workloads.
9. Document result, variance, and next experiment.

## Required Evidence

- Dataset and setup.
- Server options.
- Baseline command and result.
- Changed command and result.
- Correctness check.
- Risk to non-target workloads.

## Agent Split

- Design Agent: workload and hypothesis design.
- Code Agent: bounded implementation.
- Test Agent: benchmark and correctness execution.
- Review Agent: regression and measurement validity review.

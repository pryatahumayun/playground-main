# Configuration Management

Configuration management is the discipline of controlling and tracking changes to system components, environments, and baselines.

## Why It Matters

In complex environments, drift and undocumented changes create major risk.

Configuration management helps answer:

- what version is running
- what changed
- who changed it
- whether environments are consistent

## Key Ideas

### Baseline

A baseline is an approved reference state.

Examples:

- approved infrastructure version
- approved application release
- approved configuration set

### Change Control

Change control ensures important changes are reviewed and tracked.

### Drift

Drift means real environments no longer match the expected configuration.

## Example

If production behaves differently from test, configuration management asks:

- are the same versions deployed
- are environment variables different
- were hotfixes applied manually
- do infrastructure settings still match IaC

## Interview Phrases

- `I want a known baseline for both software and environment configuration.`
- `Uncontrolled drift makes troubleshooting and support much harder.`
- `Configuration management is about reproducibility, not just version control.`

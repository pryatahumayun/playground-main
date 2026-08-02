# Disaster Recovery

Disaster recovery explains how a system is restored after a major failure. This is bigger than normal incident response and bigger than a simple rollback. Disaster recovery is about restoring service when something serious happens, such as a regional outage, database corruption, ransomware event, or large infrastructure failure.

## What Disaster Recovery Is Trying To Answer

- what happens if the primary environment is unavailable
- how quickly service must be restored
- how much data loss the business can tolerate
- what systems must come back first
- who makes the recovery decision
- what the technical recovery steps actually are

## Two Critical Terms

### RTO

`RTO` means `Recovery Time Objective`.

It answers:

- how long can the system be down before the business impact becomes unacceptable

Example:

- if the RTO is `2 hours`, the team must restore service within two hours

### RPO

`RPO` means `Recovery Point Objective`.

It answers:

- how much data loss is acceptable

Example:

- if the RPO is `15 minutes`, the business accepts losing up to fifteen minutes of data in the worst case

## What A Disaster Recovery Document Should Include

A strong DR document usually includes these sections:

### 1. Scope

Define what system or platform the plan covers.

Example:

- customer-facing booking platform
- payment service
- production AKS cluster
- shared Azure SQL environment

### 2. Business Criticality

Explain why the system matters.

This section should describe:

- business function supported
- critical user journeys
- financial or operational impact of downtime

### 3. Recovery Objectives

Document:

- RTO
- RPO
- uptime expectations if relevant

These values should come from business needs, not just engineering preference.

### 4. Failure Scenarios

List the scenarios this plan is designed to handle.

Examples:

- region outage
- corrupted database
- deleted storage account or blob container
- cluster failure
- secrets compromise
- failed platform upgrade

### 5. Dependencies

Document the dependencies that must be recovered or validated.

Examples:

- DNS
- identity provider
- database
- queue or event bus
- object storage
- secrets store
- networking and firewalls
- third-party services

### 6. Recovery Strategy

Explain the overall recovery approach.

Examples:

- active-passive failover
- restore from backup into standby environment
- cross-region replica promotion
- rebuild infrastructure from IaC

### 7. Recovery Sequence

This is one of the most important sections.

Document the order of recovery.

Example sequence:

1. validate incident severity
2. declare DR event
3. restore networking and identity path
4. restore database or promote replica
5. restore application hosting layer
6. restore dependent services
7. validate application health
8. switch traffic or DNS
9. communicate recovery status

### 8. Roles and Responsibilities

Document who does what.

Examples:

- incident commander
- platform engineer
- database owner
- application owner
- communications lead
- security contact

### 9. Validation Steps

Recovery is not complete just because infrastructure is back up.

Document how to validate:

- service health endpoints
- user login flow
- database connectivity
- background job health
- critical business transactions

### 10. Communication Plan

Document:

- who must be notified
- how status updates are shared
- when leadership or customers are informed

### 11. Recovery Risks and Limitations

Be honest about what the plan does not guarantee.

Examples:

- reporting data may lag behind transactional data
- some background jobs may need replay
- failback to primary region may require downtime

### 12. Test History

Track:

- last DR exercise date
- results
- issues found
- actions taken

If a DR plan has never been tested, that is a major weakness.

## Example: What A DR Plan Might Look Like

Imagine an online booking system hosted in Azure.

A DR plan might say:

- primary region: `East US`
- secondary region: `Central US`
- RTO: `2 hours`
- RPO: `15 minutes`
- database recovery approach: geo-replica promotion
- application recovery approach: redeploy app from IaC and image registry
- storage recovery approach: GRS-backed storage failover plan
- DNS switch required after validation

That is much stronger than just saying "we have backups."

## Backups Are Not The Whole Plan

A common interview mistake is treating DR as a backup discussion only.

Backups matter, but DR also includes:

- restore steps
- environment rebuild
- dependency order
- application validation
- communication
- testing

A backup you cannot restore quickly is not a complete recovery strategy.

## What Interviewers Like To Hear

Strong phrases for DR answers:

- `I would define RTO and RPO with the business first because recovery design depends on them.`
- `I would document the dependency order so the team knows what must come back first.`
- `I would test the DR plan regularly because an untested recovery plan is mostly a theory.`
- `I would separate disaster recovery from simple rollback because regional or data-loss scenarios need a different response.`

## Difference Between DR and Rollback

- `Rollback` is usually about undoing a bad deployment or change
- `Disaster Recovery` is about restoring service after major failure

Example:

- bad release causing errors: rollback problem
- region outage with unavailable database: disaster recovery problem

## Quick Study Prompts

- What is the difference between RTO and RPO
- Why are backups not enough by themselves
- What dependencies usually have to be restored before an application is useful again
- Why should DR plans include communication and validation
- How would you explain the difference between failover and failback

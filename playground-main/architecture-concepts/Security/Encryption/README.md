# Encryption

Encryption protects data from unauthorized access by transforming it into a form that can only be read with the right key or trusted mechanism.

## What Encryption Is Really About

Encryption protects:

- data at rest
- data in transit
- sensitive backups
- secrets and credentials

It is a core architecture topic because systems move and store sensitive data constantly.

## Data at Rest vs Data in Transit

### Data at Rest

Examples:

- databases
- disks
- object storage
- backups

### Data in Transit

Examples:

- API calls
- browser traffic
- service-to-service communication

## Key Management Matters

Encryption is only as strong as the way keys are handled.

Architecture questions should include:

- where keys are stored
- who can access them
- how keys rotate
- what audit trail exists

## Example: Database Storage

A customer database should not rely only on perimeter security.

Stronger design:

- encrypt the database at rest
- control who can access keys
- use TLS for all client connections

## Example: Backup Protection

Encrypted production data but unencrypted backups is still weak.

This is a good interview point because people sometimes protect the primary system but forget replicas and backups.

## Encryption Is Not the Same As

- encoding
- hashing
- compression

These are often confused.

## What Interviewers Like To Hear

- `I think about both encryption and key management.`
- `Sensitive data should be protected at rest and in transit.`
- `Backups and replicas must be included in the protection model too.`

## Quick Study Prompts

- Why is key management as important as encryption itself
- What is the difference between encryption and hashing
- Why should backups be included in encryption discussions
- Why is transport security not enough by itself for sensitive data

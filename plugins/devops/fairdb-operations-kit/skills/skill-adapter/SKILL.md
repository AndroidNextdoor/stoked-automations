---
name: Managing FairDB PostgreSQL Operations
description: |
  Automatically activates when users mention FairDB, PostgreSQL operations, database provisioning, pgBackRest backups, Contabo VPS setup, customer onboarding, or database monitoring tasks. Provides comprehensive PostgreSQL-as-a-Service management including VPS provisioning, backup configuration with Wasabi S3, emergency response procedures, and automated customer database creation workflows.
---

## Overview

This skill automates complex FairDB PostgreSQL-as-a-Service operations through natural language commands. It handles everything from initial VPS provisioning on Contabo infrastructure to customer database creation, backup management with pgBackRest and Wasabi S3, and emergency incident response.

## How It Works

1. **Infrastructure Management**: Detects requests for VPS setup, PostgreSQL installation, or system configuration and executes standardized operating procedures
2. **Customer Operations**: Recognizes customer onboarding requests and automatically provisions databases, users, SSL certificates, and access controls
3. **Backup & Recovery**: Manages pgBackRest configurations, schedules backups to Wasabi S3, and handles restore operations
4. **Emergency Response**: Activates incident response protocols for critical database issues, performance problems, or service outages
5. **Monitoring & Health**: Performs comprehensive system health checks including database performance, backup status, and security audits

## When to Use This Skill

- Setting up new Contabo VPS instances for FairDB
- Installing and configuring PostgreSQL 16 for production
- Configuring pgBackRest with Wasabi S3 storage
- Onboarding new FairDB customers
- Responding to database emergencies or outages
- Performing health checks and monitoring
- Troubleshooting PostgreSQL performance issues
- Managing database backups and restores
- Automating routine maintenance tasks

## Examples

### Example 1: Customer Onboarding
User request: "I need to onboard a new FairDB customer called AcmeCorp with a 50GB database"

The skill will:
1. Execute `/fairdb-onboard-customer` command
2. Create dedicated database and users with proper permissions
3. Configure SSL certificates and network access controls
4. Set up automated backups to Wasabi S3
5. Generate connection documentation and credentials

### Example 2: Emergency Response
User request: "FairDB server is down and customers can't connect to their databases"

The skill will:
1. Activate `/fairdb-emergency-response` procedure
2. Classify as P1 Critical incident
3. Perform rapid diagnostics on PostgreSQL service, network, and resources
4. Execute recovery procedures and failover if necessary
5. Document incident timeline and root cause analysis

### Example 3: Infrastructure Setup
User request: "Set up a new FairDB server on Contabo with backup to Wasabi"

The skill will:
1. Run `/fairdb-provision-vps` for Contabo VPS setup with security hardening
2. Execute `/fairdb-install-postgres` for PostgreSQL 16 production configuration
3. Configure `/fairdb-setup-backup` with pgBackRest and Wasabi S3 integration
4. Perform comprehensive health check to verify all systems

## Best Practices

- **Security First**: Always implement security hardening, SSL certificates, and proper access controls during setup
- **Backup Verification**: Test restore procedures immediately after backup configuration
- **Documentation**: Generate comprehensive connection guides and operational documentation for customers
- **Monitoring**: Establish health check baselines before putting systems into production
- **Incident Response**: Follow structured P1-P4 classification for all issues to ensure appropriate response times

## Integration

This skill integrates with the fairdb-automation-agent for intelligent monitoring and the fairdb-backup-manager skill for advanced backup operations. It automatically coordinates with Contabo API for VPS management, Wasabi S3 for backup storage, and PostgreSQL native tools for database administration. The skill works seamlessly with existing DevOps workflows and can be triggered through natural language commands or scheduled automation tasks.
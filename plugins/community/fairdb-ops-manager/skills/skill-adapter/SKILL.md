---
name: FairDB Operations Manager
description: |
  Comprehensive PostgreSQL managed service operations toolkit. Activates when users mention:
  - Setting up PostgreSQL on a VPS or cloud server
  - Database hardening, security, or SSL/TLS configuration
  - Backup automation, pgBackRest, or disaster recovery
  - PostgreSQL health checks or monitoring
  - Incident response for database outages or disk issues
  - Managed database service operations or SOPs
  - FairDB, database operations, or DevOps automation
---

## How It Works

This plugin provides comprehensive operational guidance for running production PostgreSQL managed services. It combines step-by-step SOPs, autonomous agents, and deployment scripts.

**Workflow:**
1. **Initial Setup** - Guides through VPS hardening (SOP-001), PostgreSQL installation (SOP-002), and backup configuration (SOP-003)
2. **Daily Operations** - Health checks, backup monitoring, and compliance verification
3. **Incident Response** - Autonomous agents for P0 database down and disk full emergencies
4. **Automation** - Shell scripts for health monitoring, backup status, and SOP verification

**Key Components:**
- **SOPs:** Beginner-friendly guides (60-120 min each) for setup and configuration
- **Agents:** Autonomous setup wizard, incident responder, and ops auditor
- **Scripts:** Production-ready shell scripts for VPS deployment
- **Commands:** Quick-access operations for daily tasks

## When to Use This Skill

Activate this skill when the user mentions:

- **Setup & Configuration:**
  - "Set up PostgreSQL on a VPS"
  - "Harden a database server"
  - "Configure SSL/TLS for PostgreSQL"
  - "Set up automated backups with pgBackRest"
  - "Configure S3 backup storage (Wasabi/AWS)"

- **Operations & Monitoring:**
  - "Run a health check on PostgreSQL"
  - "Check backup status"
  - "Verify database compliance"
  - "Daily database maintenance"
  - "Monitor connection pool usage"

- **Incident Response:**
  - "Database is down"
  - "Disk space emergency"
  - "PostgreSQL won't start"
  - "Backup failures"
  - "Performance issues"

- **Managed Services:**
  - "FairDB operations"
  - "Manage multiple database servers"
  - "Database operations best practices"
  - "PostgreSQL managed service SOPs"

## Examples

**User:** "I need to set up PostgreSQL on a new VPS with proper security"

**Skill activates** → Recommends using `/agent fairdb-setup-wizard` for guided setup covering VPS hardening, PostgreSQL installation, and backup configuration (3-4 hours total). Alternatively, offers manual step-by-step approach with `/sop-001-vps-setup`, `/sop-002-postgres-install`, and `/sop-003-backup-setup`.

---

**User:** "Our production database is down, what should I do?"

**Skill activates** → Immediately suggests `/incident-p0-database-down` command or `/agent fairdb-incident-responder` for autonomous response. The agent will classify severity, run diagnostics (check service status, connectivity, logs, disk space), execute recovery procedures, and generate an incident report.

---

**User:** "How do I configure automated backups with S3?"

**Skill activates** → Provides `/sop-003-backup-setup` command (120 min guide) covering pgBackRest configuration with Wasabi S3, AES-256 encryption, automated daily/weekly backups, and **critical** backup restoration testing.

---

**User:** "I need to run a morning health check on my database servers"

**Skill activates** → Suggests `/daily-health-check` command for interactive health check routine. Also mentions the `pg-health-check.sh` script for automated monitoring via cron (checks service status, connectivity, connection pool usage, disk space, long-running queries, and backup errors).

---

**User:** "How can I verify my VPS is properly hardened?"

**Skill activates** → Recommends using the `sop-checklist.sh` script on the VPS for interactive verification of SOP-001 (VPS hardening), SOP-002 (PostgreSQL), and SOP-003 (Backups). Also suggests `/agent fairdb-ops-auditor` for comprehensive compliance auditing with remediation plans.

---

**User:** "Set up a managed PostgreSQL service with monitoring and backups"

**Skill activates** → Launches `/agent fairdb-setup-wizard` for complete automation covering:
1. VPS initial hardening (SSH keys, firewall, Fail2ban, auto-updates)
2. PostgreSQL 16 installation with SSL/TLS and performance tuning
3. pgBackRest backup configuration with S3 storage and encryption
4. Deployment of health monitoring scripts
5. Verification and documentation

Total time: 3-4 hours for production-ready setup.

## Available Commands

### Setup Commands (Manual Step-by-Step)
- `/sop-001-vps-setup` - VPS hardening guide (60 min): SSH keys, firewall, Fail2ban, security updates
- `/sop-002-postgres-install` - PostgreSQL 16 installation (90 min): SSL/TLS, performance tuning, monitoring
- `/sop-003-backup-setup` - Backup configuration (120 min): pgBackRest, S3 storage, encryption, restoration testing

### Operations Commands (Daily Tasks)
- `/daily-health-check` - Morning health check routine (10 min): Service status, connectivity, disk space
- `/incident-p0-database-down` - Database down emergency response: Diagnosis and recovery procedures
- `/incident-p0-disk-full` - Disk space emergency procedures: Rapid cleanup and long-term solutions

### Autonomous Agents (Complex Multi-Step Tasks)
- `/agent fairdb-setup-wizard` - Complete guided setup from bare VPS to production-ready
- `/agent fairdb-incident-responder` - Autonomous incident response with diagnosis and recovery
- `/agent fairdb-ops-auditor` - Compliance auditing with detailed remediation plans

### Shell Scripts (Deploy to VPS)
- `pg-health-check.sh` - Automated PostgreSQL health monitoring (schedule via cron)
- `backup-status.sh` - Visual backup health dashboard with age analysis
- `sop-checklist.sh` - Interactive SOP completion verification

## Technology Stack

**VPS Environment:**
- Ubuntu 24.04 LTS
- PostgreSQL 16
- pgBackRest 2.x
- UFW firewall + Fail2ban
- Wasabi S3 or AWS S3 (backup storage)

**Security Features:**
- SSH key authentication (password auth disabled)
- SSL/TLS for PostgreSQL connections
- AES-256 backup encryption
- Automatic security updates
- Firewall and intrusion prevention

## Best Practices

**ALWAYS remind users to:**
1. Test backup restoration regularly (weekly) - never trust untested backups
2. Use SSH key authentication (disable password auth)
3. Enable automatic security updates on VPS
4. Encrypt backups with AES-256
5. Run daily health checks and monitor backup age (<48 hours)
6. Document all changes and keep operations logs
7. Use VPS snapshots before major configuration changes

**NEVER skip:**
- Backup restoration testing (SOP-003 critical requirement)
- SSH hardening verification before closing VNC console
- PostgreSQL config syntax validation before restart
- Weekly compliance verification with `/agent fairdb-ops-auditor`

## Cost Estimate

Typical costs for small-to-medium operations:
- Contabo VPS (8GB RAM, 200GB NVMe): ~$12/month
- Wasabi storage (first 1TB free, then $6.99/TB/month)
- **Total:** ~$12-20/month per VPS

## Troubleshooting Quick Reference

| Issue | Quick Fix | Command |
|-------|-----------|---------|
| Can't SSH after hardening | Use VNC console, restore sshd_config.backup | `sudo cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config` |
| PostgreSQL won't start | Check logs, test config syntax | `sudo tail -100 /var/log/postgresql/postgresql-16-main.log` |
| Backup failures | Test internet, verify credentials | `sudo -u postgres pgbackrest --stanza=main check` |
| Disk space emergency | Run cleanup procedures | `/incident-p0-disk-full` |
| Database down | Autonomous incident response | `/agent fairdb-incident-responder` |

## Support & Documentation

- **Plugin Repository:** https://github.com/AndroidNextdoor/stoked-automations
- **Author:** Intent Solutions IO (andrew@stokedautomation.com)
- **Target Service:** FairDB - transparent, affordable, managed PostgreSQL
- **Version:** 2025.0.0
- **License:** MIT
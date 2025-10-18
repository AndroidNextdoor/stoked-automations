# Skills Generation Audit Database

This directory contains the SQLite audit trail for Agent Skills generation via `vertex-skills-generator-safe.py`.

## Database: `skills_generation.db`

### Tables

1. **skill_generations** - Main audit log
   - `id` - Auto-incrementing primary key
   - `timestamp` - ISO format timestamp
   - `plugin_name` - Name of the plugin
   - `plugin_category` - Category (devops, security, etc.)
   - `plugin_path` - **ABSOLUTE PATH** to plugin directory
   - `status` - SUCCESS, ERROR, or VALIDATION_FAILED
   - `char_count` - Number of characters in generated skill
   - `line_count` - Number of lines in generated skill
   - `error_message` - Error details if failed
   - `generation_time_seconds` - Time taken to generate
   - `skill_content` - Full SKILL.md content

2. **validation_failures** - Failed validation attempts
   - `id` - Auto-incrementing primary key
   - `timestamp` - ISO format timestamp
   - `plugin_name` - Name of the plugin
   - `reason` - Validation failure reason
   - `details` - Additional details

### Known Issue: Absolute Paths

⚠️ **IMPORTANT**: The database stores **absolute paths** (e.g., `/home/jeremy/000-projects/claude-code-plugins/plugins/...`).

When the codebase is:
- Cloned to a new machine
- Moved to a different directory
- Transferred between users

These paths become incorrect.

### Solution: Update Paths Script

Run the path update script to fix all paths:

```bash
# From repository root
./scripts/update-skills-db-paths.sh backups/skills-audit/skills_generation.db $(pwd)
```

This will:
1. Create a timestamped backup
2. Show current paths and what will change
3. Prompt for confirmation
4. Update all paths to current machine
5. Verify the update

### Preventing This Issue

To prevent this in future skill generation runs, modify `scripts/vertex-skills-generator-safe.py` line 108:

**Current (stores absolute path):**
```python
str(plugin_path),  # Convert Path to string for SQLite
```

**Better (stores relative path):**
```python
str(plugin_path.relative_to(repo_root)),  # Relative path from repo root
```

This way paths remain valid regardless of where the repository is located.

## Querying the Database

### Basic Statistics

```bash
# View success rate
sqlite3 skills_generation.db "
  SELECT
    status,
    COUNT(*) as count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) as percentage
  FROM skill_generations
  GROUP BY status
"
```

### Recently Generated Skills

```bash
sqlite3 skills_generation.db "
  SELECT
    plugin_name,
    plugin_category,
    status,
    line_count,
    ROUND(generation_time_seconds, 2) as time_sec
  FROM skill_generations
  ORDER BY timestamp DESC
  LIMIT 10
"
```

### Failed Generations

```bash
sqlite3 skills_generation.db "
  SELECT
    plugin_name,
    error_message
  FROM skill_generations
  WHERE status IN ('ERROR', 'VALIDATION_FAILED')
"
```

### Average Generation Time by Category

```bash
sqlite3 skills_generation.db "
  SELECT
    plugin_category,
    COUNT(*) as count,
    ROUND(AVG(generation_time_seconds), 2) as avg_time,
    ROUND(AVG(line_count), 0) as avg_lines
  FROM skill_generations
  WHERE status = 'SUCCESS'
  GROUP BY plugin_category
  ORDER BY avg_time DESC
"
```

### Verify Paths Are Correct

```bash
# Check for paths that don't match current machine
sqlite3 skills_generation.db "
  SELECT DISTINCT
    SUBSTR(plugin_path, 1, 60) as path_prefix,
    COUNT(*) as count
  FROM skill_generations
  GROUP BY path_prefix
"
```

## Backup and Restore

### Create Backup

```bash
cp skills_generation.db skills_generation.db.backup.$(date +%Y%m%d)
```

### Restore from Backup

```bash
cp skills_generation.db.backup.20251018 skills_generation.db
```

## Integration with Vertex Generator

The database is automatically created and populated when running:

```bash
# Generate skills for priority plugins
python3 scripts/vertex-skills-generator-safe.py --priority

# View statistics
python3 scripts/vertex-skills-generator-safe.py --stats

# Process specific plugin
python3 scripts/vertex-skills-generator-safe.py plugin-name
```

## See Also

- [vertex-skills-generator-safe.py](../../scripts/vertex-skills-generator-safe.py) - Main skill generation script
- [update-skills-db-paths.sh](../../scripts/update-skills-db-paths.sh) - Path update utility
- [PRODUCTION_SAFETY_GUIDE.md](../../scripts/PRODUCTION_SAFETY_GUIDE.md) - Safety guidelines

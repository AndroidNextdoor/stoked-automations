#!/bin/bash
# Check skill generation history in database

DB_PATH="backups/skills-audit/skills_generation.db"

echo "=== Skill Generation Summary ==="
echo ""
echo "Total records by status:"
sqlite3 "$DB_PATH" "SELECT status, COUNT(*) as count FROM skill_generations GROUP BY status ORDER BY status"

echo ""
echo "Recent Claude SUCCESS (today):"
sqlite3 "$DB_PATH" "SELECT timestamp, plugin_name, char_count, line_count, printf('%.2f', generation_time_seconds) as gen_time FROM skill_generations WHERE status = 'SUCCESS' AND timestamp >= date('now') ORDER BY timestamp DESC LIMIT 10"

echo ""
echo "Recent ERROR records:"
sqlite3 "$DB_PATH" "SELECT timestamp, plugin_name, substr(error_message, 1, 80) as error FROM skill_generations WHERE status = 'ERROR' ORDER BY timestamp DESC LIMIT 5"

echo ""
echo "Generation stats:"
sqlite3 "$DB_PATH" "SELECT 
  status,
  COUNT(*) as total,
  printf('%.1f', AVG(char_count)) as avg_chars,
  printf('%.1f', AVG(line_count)) as avg_lines,
  printf('%.2f', AVG(generation_time_seconds)) as avg_time_sec
FROM skill_generations 
WHERE status = 'SUCCESS'
GROUP BY status"

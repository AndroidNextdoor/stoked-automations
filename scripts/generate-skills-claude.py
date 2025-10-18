#!/usr/bin/env python3
"""
Claude API Skills Generator
Uses Anthropic's Claude API for high-quality skill generation

Rate Limiting:
- Multi-threaded with controlled concurrency (5 concurrent requests)
- Rate limiter enforces ~12 requests per minute (5 RPM free tier safe)
- 3 retry attempts with exponential backoff
- Handles 429 quota errors gracefully

Claude Tier Limits:
- Free tier: 5 RPM, 50 requests per day
- Tier 1: 1000 RPM, 150K TPM
- Tier 2: 2000 RPM, 400K TPM
"""

import json
import os
import sys
import time
import threading
import sqlite3
from datetime import datetime
from pathlib import Path
from anthropic import Anthropic
from concurrent.futures import ThreadPoolExecutor, as_completed

# Rate limiting configuration
MAX_WORKERS = 5  # Max concurrent API calls
REQUESTS_PER_MINUTE = 4  # Conservative for free tier (5 RPM limit)
MIN_REQUEST_INTERVAL = 60.0 / REQUESTS_PER_MINUTE  # ~15 seconds between requests
MAX_RETRIES = 3
RETRY_DELAY = 10  # Start with 10 seconds, doubles each retry

# Global rate limiter
class RateLimiter:
    def __init__(self, min_interval):
        self.min_interval = min_interval
        self.last_request_time = 0
        self.lock = threading.Lock()

    def wait_if_needed(self):
        """Wait if we need to throttle requests"""
        with self.lock:
            current_time = time.time()
            time_since_last = current_time - self.last_request_time
            if time_since_last < self.min_interval:
                wait_time = self.min_interval - time_since_last
                time.sleep(wait_time)
            self.last_request_time = time.time()

rate_limiter = RateLimiter(MIN_REQUEST_INTERVAL)

# Database logging
DB_LOCK = threading.Lock()

def log_to_database(repo_root, plugin_name, plugin_category, plugin_path, status,
                   char_count=None, line_count=None, error_message=None,
                   generation_time=None, skill_content=None):
    """Log skill generation to database"""
    db_path = repo_root / 'backups' / 'skills-audit' / 'skills_generation.db'

    # Skip if database doesn't exist
    if not db_path.exists():
        return

    with DB_LOCK:
        try:
            conn = sqlite3.connect(str(db_path))
            cursor = conn.cursor()

            timestamp = datetime.utcnow().isoformat()

            # If this is a SUCCESS, delete any previous ERROR records for this plugin
            if status == 'SUCCESS':
                cursor.execute("""
                    DELETE FROM skill_generations
                    WHERE plugin_name = ? AND status = 'ERROR'
                """, (plugin_name,))

            cursor.execute("""
                INSERT INTO skill_generations
                (timestamp, plugin_name, plugin_category, plugin_path, status,
                 char_count, line_count, error_message, generation_time_seconds, skill_content)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (timestamp, plugin_name, plugin_category, str(plugin_path), status,
                  char_count, line_count, error_message, generation_time, skill_content))

            conn.commit()
            conn.close()
        except Exception as e:
            # Don't fail the whole process if DB logging fails
            print(f"  ⚠️  Database logging failed: {e}")

def read_plugin_context(plugin_path):
    """Read plugin files to understand what it does"""
    base = Path(plugin_path)
    context = []

    # Read plugin.json
    plugin_json = base / '.claude-plugin' / 'plugin.json'
    if plugin_json.exists():
        context.append(f"=== plugin.json ===\n{plugin_json.read_text()}\n")

    # Read README (first 3000 chars)
    readme = base / 'README.md'
    if readme.exists():
        content = readme.read_text()[:3000]
        context.append(f"=== README.md ===\n{content}\n")

    # Sample commands
    commands_dir = base / 'commands'
    if commands_dir.exists():
        cmd_files = list(commands_dir.glob('*.md'))[:2]
        for cmd in cmd_files:
            context.append(f"=== Command: {cmd.name} ===\n{cmd.read_text()[:600]}\n")

    # Sample agents
    agents_dir = base / 'agents'
    if agents_dir.exists():
        agent_files = list(agents_dir.glob('*.md'))[:2]
        for agent in agent_files:
            context.append(f"=== Agent: {agent.name} ===\n{agent.read_text()[:600]}\n")

    return "\n".join(context)

def generate_skill(plugin_name, plugin_path, api_key):
    """Generate SKILL.md using Claude API with rate limiting"""

    # Apply rate limiting before making API call
    rate_limiter.wait_if_needed()

    # Initialize Claude client
    client = Anthropic(api_key=api_key)

    context = read_plugin_context(plugin_path)

    # Read plugin.json for metadata
    plugin_json_path = Path(plugin_path) / '.claude-plugin' / 'plugin.json'
    with open(plugin_json_path, 'r') as f:
        plugin_data = json.load(f)

    plugin_desc = plugin_data.get('description', '')
    plugin_category = plugin_data.get('category', 'productivity')

    prompt = f"""You are an expert at creating Agent Skills for Claude Code following Anthropic's official guidelines.

CONTEXT - What You're Creating:

Claude Code is Anthropic's CLI tool for software development. Users install PLUGINS (extensions) to add capabilities.

AGENT SKILLS are instruction manuals (SKILL.md files) that teach Claude Code:
- WHEN to automatically activate a specific plugin (trigger phrases)
- HOW to use the plugin effectively (workflow steps)
- WHAT the plugin is best used for (examples and scenarios)

OFFICIAL ANTHROPIC REQUIREMENTS:
- YAML frontmatter with ONLY two fields: 'name' and 'description' (no other fields allowed)
- name: Max 64 characters, use gerund form (e.g., "Processing PDFs", "Analyzing Security")
- description: Max 1024 characters, third person, explain WHAT it does and WHEN to use it
- Keep total length under 500 lines (Anthropic recommendation)
- Be concise and specific to THIS plugin's purpose

PLUGIN DETAILS:
- Name: {plugin_name}
- Category: {plugin_category}
- Description: {plugin_desc}

PLUGIN FILES:
{context}

Generate a complete SKILL.md file following this structure:

---
name: [Gerund-form name, max 64 chars]
description: |
  [Third-person description, max 1024 chars. Include specific trigger terms.]
---

## Overview
[2-3 sentence overview]

## How It Works
1. **[Step]**: [Description]
2. **[Step]**: [Description]
3. **[Step]**: [Description]

## When to Use This Skill
- [Trigger scenario 1]
- [Trigger scenario 2]
- [Trigger scenario 3]

## Examples

### Example 1: [Use Case]
User request: "[Natural language request]"

The skill will:
1. [Action]
2. [Result]

### Example 2: [Another Scenario]
User request: "[Request]"

The skill will:
1. [Action]
2. [Result]

## Best Practices
- **[Category]**: [Advice]
- **[Category]**: [Advice]

## Integration
[How this works with other tools/plugins]

CRITICAL: Keep under 500 lines, be specific to {plugin_name}, NO placeholders."""

    # Retry loop with exponential backoff
    for attempt in range(MAX_RETRIES):
        try:
            message = client.messages.create(
                model="claude-sonnet-4-20250514",
                max_tokens=4096,
                messages=[{
                    "role": "user",
                    "content": prompt
                }]
            )

            content = message.content[0].text

            # Strip markdown code fences if present
            content = content.strip()
            if content.startswith('```'):
                lines = content.split('\n')
                lines = lines[1:]
                if lines and lines[-1].strip() == '```':
                    lines = lines[:-1]
                content = '\n'.join(lines).strip()

            return content

        except Exception as e:
            error_msg = str(e)

            # Check if it's a quota error (429)
            if '429' in error_msg or 'quota' in error_msg.lower() or 'rate limit' in error_msg.lower():
                retry_delay = RETRY_DELAY * (2 ** attempt)  # Exponential backoff
                print(f"  ⚠️  Rate limit exceeded (attempt {attempt + 1}/{MAX_RETRIES})")

                if attempt < MAX_RETRIES - 1:
                    print(f"  ⏳ Waiting {retry_delay} seconds before retry...")
                    time.sleep(retry_delay)
                    continue
                else:
                    print(f"  ❌ Max retries reached. Rate limit still exceeded.")
                    raise Exception(f"Rate limit exceeded after {MAX_RETRIES} attempts")
            else:
                # Non-quota error, raise immediately
                raise e

    return None

def process_plugin(plugin_info, api_key, repo_root, completed_count, total_plugins, lock):
    """Process a single plugin (called by thread pool)"""
    plugin_name, plugin_data = plugin_info

    with lock:
        current = completed_count[0]
        completed_count[0] += 1
        print(f"\n🎯 [{current}/{total_plugins}] Processing: {plugin_name}")

    plugin_path = repo_root / plugin_data['source'].lstrip('./')
    skill_file = plugin_path / 'skills' / 'skill-adapter' / 'SKILL.md'

    # Get plugin category from plugin.json
    try:
        plugin_json_path = plugin_path / '.claude-plugin' / 'plugin.json'
        with open(plugin_json_path, 'r') as f:
            plugin_json = json.load(f)
        plugin_category = plugin_json.get('category', 'unknown')
    except:
        plugin_category = 'unknown'

    # Skip if already exists
    if skill_file.exists():
        print(f"  ⏭️  {plugin_name}: SKILL.md already exists")
        return {'status': 'skipped', 'plugin': plugin_name}

    start_time = time.time()

    try:
        print(f"  🤖 {plugin_name}: Generating with Claude API...")
        skill_content = generate_skill(plugin_name, plugin_path, api_key)

        if skill_content:
            skill_file.parent.mkdir(parents=True, exist_ok=True)
            skill_file.write_text(skill_content)

            line_count = len(skill_content.split('\n'))
            char_count = len(skill_content)
            generation_time = time.time() - start_time

            # Log success to database
            log_to_database(
                repo_root=repo_root,
                plugin_name=plugin_name,
                plugin_category=plugin_category,
                plugin_path=plugin_path,
                status='SUCCESS',
                char_count=char_count,
                line_count=line_count,
                generation_time=generation_time,
                skill_content=skill_content
            )

            print(f"  ✅ {plugin_name}: Created SKILL.md ({char_count} chars, {line_count} lines)")
            return {'status': 'success', 'plugin': plugin_name, 'chars': char_count, 'lines': line_count}

    except Exception as e:
        generation_time = time.time() - start_time
        error_message = str(e)

        # Log error to database
        log_to_database(
            repo_root=repo_root,
            plugin_name=plugin_name,
            plugin_category=plugin_category,
            plugin_path=plugin_path,
            status='ERROR',
            error_message=error_message,
            generation_time=generation_time
        )

        print(f"  ❌ {plugin_name}: Error - {e}")
        return {'status': 'error', 'plugin': plugin_name, 'error': str(e)}

    return {'status': 'failed', 'plugin': plugin_name}

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 generate-skills-claude.py <plugin-name> [<plugin-name2> ...]")
        print("\nExamples:")
        print("  python3 generate-skills-claude.py project-health-auditor")
        print("  python3 generate-skills-claude.py plugin1 plugin2 plugin3")
        print("\nRate Limiting (Multi-threaded):")
        print(f"  - Max concurrent workers: {MAX_WORKERS}")
        print(f"  - Rate limit: {REQUESTS_PER_MINUTE} requests per minute")
        print(f"  - Min interval between requests: {MIN_REQUEST_INTERVAL:.1f} seconds")
        print(f"  - Max retries: {MAX_RETRIES} with exponential backoff")
        print("\nRequires ANTHROPIC_API_KEY environment variable")
        print("  Set it with: export ANTHROPIC_API_KEY='your-api-key'")
        print("  Get your key at: https://console.anthropic.com/settings/keys")
        sys.exit(1)

    api_key = os.environ.get('ANTHROPIC_API_KEY')
    if not api_key:
        print("❌ Error: ANTHROPIC_API_KEY environment variable not set")
        print("\nSet it with:")
        print("  export ANTHROPIC_API_KEY='your-api-key'")
        print("\nGet your API key at:")
        print("  https://console.anthropic.com/settings/keys")
        sys.exit(1)

    repo_root = Path(__file__).parent.parent
    marketplace_file = repo_root / '.claude-plugin' / 'marketplace.json'

    with open(marketplace_file, 'r') as f:
        marketplace = json.load(f)

    plugin_names = sys.argv[1:]
    total_plugins = len(plugin_names)

    # Filter plugins to process
    plugins_to_process = []
    for plugin_name in plugin_names:
        plugin = next((p for p in marketplace['plugins'] if p['name'] == plugin_name), None)
        if not plugin:
            print(f"  ❌ Plugin '{plugin_name}' not found in marketplace")
            continue
        plugins_to_process.append((plugin_name, plugin))

    actual_count = len(plugins_to_process)
    estimated_time = (actual_count * MIN_REQUEST_INTERVAL) / 60

    print(f"\n⚙️  Multi-threaded Rate Limiting Configuration:")
    print(f"   - Total plugins to process: {actual_count}")
    print(f"   - Concurrent workers: {MAX_WORKERS}")
    print(f"   - Rate limit: {REQUESTS_PER_MINUTE} requests/minute (~{MIN_REQUEST_INTERVAL:.1f}s between calls)")
    print(f"   - Estimated time: ~{estimated_time:.1f} minutes")
    print(f"   - Using Claude Sonnet 4.5 for high-quality generation\n")

    # Thread-safe counter and lock
    completed_count = [1]  # Mutable list for thread-safe counter
    lock = threading.Lock()

    # Results tracking
    results = {'success': 0, 'skipped': 0, 'error': 0}

    # Process plugins with ThreadPoolExecutor
    start_time = time.time()
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        # Submit all tasks
        future_to_plugin = {
            executor.submit(process_plugin, plugin_info, api_key, repo_root, completed_count, actual_count, lock): plugin_info[0]
            for plugin_info in plugins_to_process
        }

        # Collect results as they complete
        for future in as_completed(future_to_plugin):
            result = future.result()
            results[result['status']] += 1

    elapsed_time = time.time() - start_time

    print(f"\n✅ Batch generation complete!")
    print(f"\n📊 Summary:")
    print(f"   - Successful: {results['success']}")
    print(f"   - Skipped (existing): {results['skipped']}")
    print(f"   - Errors: {results['error']}")
    print(f"   - Total time: {elapsed_time / 60:.1f} minutes")

if __name__ == '__main__':
    main()

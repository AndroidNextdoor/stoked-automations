#!/usr/bin/env python3
"""
Simple Gemini API Skills Generator
Uses Google Gemini API (not Vertex AI) - just needs an API key

Rate Limiting:
- 60 second delay between API calls (very conservative)
- 3 retry attempts with exponential backoff
- Handles 429 quota errors gracefully
"""

import json
import os
import sys
import time
from pathlib import Path
import google.generativeai as genai

# Rate limiting configuration
RATE_LIMIT_DELAY = 60  # 60 seconds between API calls (ultra conservative)
MAX_RETRIES = 3
RETRY_DELAY = 10  # Start with 10 seconds, doubles each retry

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
    """Generate SKILL.md using Gemini API"""

    # Configure Gemini
    genai.configure(api_key=api_key)
    model = genai.GenerativeModel('gemini-2.0-flash-exp')

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

PLUGIN DETAILS:
- Name: {plugin_name}
- Category: {plugin_category}
- Description: {plugin_desc}

PLUGIN FILES:
{context}

Generate a complete SKILL.md file with YAML frontmatter (name and description only), overview, how it works, when to use, examples, and best practices. Keep under 500 lines total."""

    # Retry loop with exponential backoff
    for attempt in range(MAX_RETRIES):
        try:
            response = model.generate_content(prompt)
            content = response.text

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
                print(f"  ⚠️  Quota exceeded (attempt {attempt + 1}/{MAX_RETRIES})")

                if attempt < MAX_RETRIES - 1:
                    print(f"  ⏳ Waiting {retry_delay} seconds before retry...")
                    time.sleep(retry_delay)
                    continue
                else:
                    print(f"  ❌ Max retries reached. Quota still exceeded.")
                    raise Exception(f"Quota exceeded after {MAX_RETRIES} attempts")
            else:
                # Non-quota error, raise immediately
                raise e

    return None

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 generate-skills-gemini.py <plugin-name> [<plugin-name2> ...]")
        print("\nExamples:")
        print("  python3 generate-skills-gemini.py project-health-auditor")
        print("  python3 generate-skills-gemini.py plugin1 plugin2 plugin3")
        print("\nRate Limiting:")
        print(f"  - {RATE_LIMIT_DELAY} second delay between API calls (very conservative)")
        print(f"  - {MAX_RETRIES} retry attempts with exponential backoff")
        print(f"  - Handles 429 quota errors gracefully")
        print("\nRequires GEMINI_API_KEY environment variable")
        print("  Set it with: export GEMINI_API_KEY='your-api-key'")
        sys.exit(1)

    api_key = os.environ.get('GEMINI_API_KEY')
    if not api_key:
        print("❌ Error: GEMINI_API_KEY environment variable not set")
        print("\nSet it with:")
        print("  export GEMINI_API_KEY='your-api-key-here'")
        sys.exit(1)

    repo_root = Path(__file__).parent.parent
    marketplace_file = repo_root / '.claude-plugin' / 'marketplace.json'

    with open(marketplace_file, 'r') as f:
        marketplace = json.load(f)

    plugin_names = sys.argv[1:]
    total_plugins = len(plugin_names)

    print(f"\n⚙️  Rate Limiting Configuration:")
    print(f"   - Delay between calls: {RATE_LIMIT_DELAY} seconds")
    print(f"   - Max retries per plugin: {MAX_RETRIES}")
    print(f"   - Estimated time: ~{(total_plugins * RATE_LIMIT_DELAY) / 60:.1f} minutes\n")

    for idx, plugin_name in enumerate(plugin_names, 1):
        print(f"\n🎯 [{idx}/{total_plugins}] Generating skill for: {plugin_name}")

        plugin = next((p for p in marketplace['plugins'] if p['name'] == plugin_name), None)
        if not plugin:
            print(f"  ❌ Plugin '{plugin_name}' not found in marketplace")
            continue

        plugin_path = repo_root / plugin['source'].lstrip('./')

        skill_file = plugin_path / 'skills' / 'skill-adapter' / 'SKILL.md'
        if skill_file.exists():
            print(f"  ⏭️  SKILL.md already exists")
            continue

        try:
            print(f"  🤖 Generating with Gemini API...")
            skill_content = generate_skill(plugin_name, plugin_path, api_key)

            if skill_content:
                skill_file.parent.mkdir(parents=True, exist_ok=True)
                skill_file.write_text(skill_content)

                line_count = len(skill_content.split('\n'))
                char_count = len(skill_content)
                print(f"  ✅ Created SKILL.md ({char_count} chars, {line_count} lines)")

        except Exception as e:
            print(f"  ❌ Error: {e}")

        # Rate limiting: wait between API calls (except for last plugin)
        if idx < total_plugins:
            print(f"  ⏳ Rate limiting: waiting {RATE_LIMIT_DELAY} seconds before next plugin...")
            time.sleep(RATE_LIMIT_DELAY)

if __name__ == '__main__':
    main()

# Claude API Migration Checklist

**Status:** Ready for testing and deployment
**Created:** 2025-10-18
**Purpose:** Complete migration from Gemini to Claude API for skill generation

## Overview

This checklist guides you through completing the Claude API migration for skill generation. All code is written and documented - just needs testing and deployment.

**Why Claude?**
- Higher quality skill generation
- Better rate limits (1000+ RPM on paid tiers vs 360 RPM Gemini)
- More consistent output formatting
- Official Anthropic tool
- Cost: ~$0.03 per skill (very affordable)

## Prerequisites

- [ ] Claude API account with active API key
- [ ] Python 3.x installed
- [ ] Anthropic Python SDK installed (`pip3 install --break-system-packages anthropic`)

## Step 1: Get Claude API Key

1. Visit https://console.anthropic.com/settings/keys
2. Create a new API key
3. Copy the key (starts with `sk-ant-api03-`)
4. **Keep it secure** - treat like a password

## Step 2: Set Environment Variable

Add to your shell configuration file:

**For zsh (default on macOS):**
```bash
echo "export ANTHROPIC_API_KEY='sk-ant-api03-your-key-here'" >> ~/.zshrc
source ~/.zshrc
```

**For bash:**
```bash
echo "export ANTHROPIC_API_KEY='sk-ant-api03-your-key-here'" >> ~/.bashrc
source ~/.bashrc
```

**Verify it's set:**
```bash
echo $ANTHROPIC_API_KEY
# Should output your API key
```

## Step 3: Test Claude Script

### Quick Test (Single Plugin)

Pick a plugin that doesn't have a SKILL.md yet:

```bash
cd /Users/andrew.nixdorf/Projects/stoked-automations

# Find plugins without skills:
python3 scripts/generate-skills-claude.py --help

# Test with a single plugin (replace with actual plugin name):
python3 scripts/generate-skills-claude.py plugin-name-here
```

**Expected output:**
```
⚙️  Rate Limiting Configuration:
   - Delay between calls: 30 seconds
   - Max retries per plugin: 3
   - Estimated time: ~0.5 minutes

🎯 [1/1] Generating skill for: plugin-name
  🤖 Generating with Claude API...
  ✅ Created SKILL.md (2847 chars, 89 lines)
```

**Check the generated file:**
```bash
# View the generated SKILL.md:
cat plugins/*/plugin-name/skills/skill-adapter/SKILL.md

# Should have:
# - YAML frontmatter (name, description)
# - Overview section
# - How It Works section
# - When to Use section
# - Examples
# - Best Practices
```

### Batch Test (3-5 Plugins)

Test with a small batch to verify rate limiting:

```bash
# Get list of plugins without skills:
sqlite3 backups/skills-audit/skills_generation.db \
  "SELECT DISTINCT p.name FROM marketplace_plugins p
   LEFT JOIN skill_generations s ON p.name = s.plugin_name
   WHERE s.plugin_name IS NULL
   LIMIT 5"

# Run batch test:
python3 scripts/generate-skills-claude.py plugin1 plugin2 plugin3
```

**Watch for:**
- ✅ 30-second delays between plugins
- ✅ Successful SKILL.md creation
- ✅ No rate limit errors (429)
- ✅ Consistent file format

## Step 4: Compare Quality with Gemini

Generate skills for the same plugin using both tools:

```bash
# Backup existing SKILL.md if present:
mv plugins/category/test-plugin/skills/skill-adapter/SKILL.md \
   plugins/category/test-plugin/skills/skill-adapter/SKILL.md.backup

# Generate with Gemini:
python3 scripts/generate-skills-gemini.py test-plugin
mv plugins/category/test-plugin/skills/skill-adapter/SKILL.md \
   plugins/category/test-plugin/skills/skill-adapter/SKILL.md.gemini

# Generate with Claude:
python3 scripts/generate-skills-claude.py test-plugin
mv plugins/category/test-plugin/skills/skill-adapter/SKILL.md \
   plugins/category/test-plugin/skills/skill-adapter/SKILL.md.claude

# Compare:
diff plugins/category/test-plugin/skills/skill-adapter/SKILL.md.gemini \
     plugins/category/test-plugin/skills/skill-adapter/SKILL.md.claude
```

**Quality checklist:**
- [ ] Claude output has better structure
- [ ] More specific examples
- [ ] Better instruction following
- [ ] Consistent YAML frontmatter formatting
- [ ] Appropriate length (not too short/long)

## Step 5: Commit Changes

Once testing passes, commit all Claude-related files:

```bash
cd /Users/andrew.nixdorf/Projects/stoked-automations

# Check what's modified:
git status

# Add Claude script and documentation:
git add scripts/generate-skills-claude.py
git add scripts/CLAUDE_RATE_LIMITS.md
git add scripts/CLAUDE_MIGRATION_CHECKLIST.md
git add docs/getting-started.md

# Commit with descriptive message:
git commit -m "Add Claude API skill generator (recommended over Gemini)

- Add scripts/generate-skills-claude.py - primary skill generator
- Uses Claude Sonnet 4.5 for higher quality output
- 30s rate limiting (2 RPM) safe for free tier (5 RPM limit)
- Exponential backoff retry (10s, 20s, 40s)
- Cost: ~\$0.03 per skill generation

- Add scripts/CLAUDE_RATE_LIMITS.md - comprehensive usage guide
  - Rate limit tiers (Free: 5 RPM, Tier 1: 1000 RPM)
  - Cost analysis and comparison with alternatives
  - Migration guide from Gemini

- Update docs/getting-started.md
  - Recommend Claude API as primary option
  - Gemini as alternative fallback
  - Environment variable setup instructions

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Step 6: Update Documentation (Optional)

Consider updating other docs to mention Claude option:

- [ ] **README.md** - Add Claude as skill generation option
- [ ] **CONTRIBUTING.md** - Recommend Claude for contributors
- [ ] **backups/skills-audit/README.md** - Document Claude usage

## Step 7: Production Usage

### Generate All Missing Skills

```bash
# Get count of plugins without skills:
sqlite3 backups/skills-audit/skills_generation.db \
  "SELECT COUNT(*) FROM marketplace_plugins p
   LEFT JOIN skill_generations s ON p.name = s.plugin_name
   WHERE s.plugin_name IS NULL"

# Get list of all plugins without skills:
sqlite3 backups/skills-audit/skills_generation.db \
  "SELECT name FROM marketplace_plugins p
   LEFT JOIN skill_generations s ON p.name = s.plugin_name
   WHERE s.plugin_name IS NULL" > /tmp/missing-skills.txt

# Generate all (with progress tracking):
python3 scripts/generate-skills-claude.py $(cat /tmp/missing-skills.txt | tr '\n' ' ')
```

**Time estimates:**
- 10 plugins: ~5 minutes (10 × 30s)
- 50 plugins: ~25 minutes (50 × 30s)
- 61 plugins (current missing): ~30 minutes

**Cost estimates:**
- 10 plugins: ~$0.30
- 50 plugins: ~$1.50
- 61 plugins: ~$1.83

### Update stats.json

After generating new skills:

```bash
# Count plugins with skills:
SKILLS_COUNT=$(find plugins -name "SKILL.md" | wc -l | tr -d ' ')

# Update stats.json:
jq ".pluginsWithSkills = $SKILLS_COUNT | .lastUpdated = \"$(date +%Y-%m-%d)\"" \
  .claude-plugin/stats.json > /tmp/stats.json && \
  mv /tmp/stats.json .claude-plugin/stats.json

# Commit:
git add .claude-plugin/stats.json plugins/
git commit -m "Generate Agent Skills for $SKILLS_COUNT plugins using Claude API"
```

## Rollback Procedures

### If Claude Script Has Issues

**Option 1: Use Gemini as fallback**
```bash
# Gemini still works with rate limiting:
python3 scripts/generate-skills-gemini.py plugin-name
```

**Option 2: Revert to previous commit**
```bash
git log --oneline -5  # Find commit before Claude changes
git revert <commit-hash>
```

### If API Key Issues

**Check API key validity:**
```bash
# Test with curl:
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "content-type: application/json" \
  -H "anthropic-version: 2023-06-01" \
  -d '{
    "model": "claude-sonnet-4-20250514",
    "max_tokens": 10,
    "messages": [{"role": "user", "content": "Hi"}]
  }'

# Should return JSON response, not 401 error
```

### If Rate Limits Hit

**Check your rate tier:**
- Free tier: 5 RPM (wait 1 minute between batches)
- Tier 1 ($5+ spent): 1000 RPM (can reduce delay to 10s)
- Tier 2 ($40+ spent): 2000 RPM (can reduce delay to 5s)

**Adjust delay if needed:**
```python
# Edit scripts/generate-skills-claude.py:
RATE_LIMIT_DELAY = 60  # Increase to 60s for ultra-safe
```

## Monitoring Usage

**Check Claude API usage:**
- Visit: https://console.anthropic.com/settings/usage
- Monitor: Request count, token consumption
- Verify: You're within daily/monthly limits

**Check database for errors:**
```bash
sqlite3 backups/skills-audit/skills_generation.db \
  "SELECT COUNT(*) FROM skill_generations WHERE status = 'ERROR' AND timestamp > datetime('now', '-1 day')"

# Should be 0 or very low
```

## Troubleshooting

### Error: "ANTHROPIC_API_KEY environment variable not set"

**Solution:**
```bash
export ANTHROPIC_API_KEY='sk-ant-api03-your-key-here'
# Or add to ~/.zshrc permanently
```

### Error: "Rate limit exceeded after 3 attempts"

**Solutions:**
1. Wait 1-2 minutes (rate limits reset every minute)
2. Increase `RATE_LIMIT_DELAY` to 60 seconds
3. Upgrade to Tier 1 (need $5+ spent)

### Error: "Module 'anthropic' not found"

**Solution:**
```bash
pip3 install --break-system-packages anthropic
# Or use virtual environment:
python3 -m venv venv
source venv/bin/activate
pip install anthropic
```

### Generated Skills Are Low Quality

**Check:**
1. Using correct model: `claude-sonnet-4-20250514`
2. Prompt includes full plugin context
3. SKILL.md format matches expectations

**Compare with Gemini:**
```bash
# Generate same plugin with both:
python3 scripts/generate-skills-gemini.py plugin-name
mv plugins/.../SKILL.md plugins/.../SKILL.md.gemini

python3 scripts/generate-skills-claude.py plugin-name
diff plugins/.../SKILL.md.gemini plugins/.../SKILL.md
```

## Success Criteria

- [ ] Claude script runs without errors
- [ ] SKILL.md files are generated with proper format
- [ ] Quality is superior to Gemini output
- [ ] Rate limiting prevents quota errors
- [ ] Cost is acceptable (~$0.03/skill)
- [ ] Documentation is updated
- [ ] Changes are committed to git

## Resources

### Documentation Created
- `scripts/CLAUDE_RATE_LIMITS.md` - Comprehensive usage guide
- `scripts/GEMINI_RATE_LIMITS.md` - Gemini fallback guide
- `docs/getting-started.md` - API key setup instructions

### Related Scripts
- `scripts/generate-skills-claude.py` - Primary generator (NEW)
- `scripts/generate-skills-gemini.py` - Fallback option
- `scripts/vertex-skills-generator-safe.py` - Legacy (requires GCP)

### External Links
- Claude API Console: https://console.anthropic.com/
- Claude API Docs: https://docs.anthropic.com/en/api/
- Rate Limits: https://docs.anthropic.com/en/api/rate-limits
- Pricing: https://www.anthropic.com/pricing

## Next Steps After Completion

1. **Monitor performance** for 1 week
   - Track error rates in database
   - Compare quality with Gemini
   - Monitor API costs

2. **Update marketplace website** if needed
   - Add "Powered by Claude" badge
   - Update skill generation stats

3. **Generate remaining skills**
   - 61 plugins still need skills
   - Estimated cost: ~$1.83
   - Estimated time: ~30 minutes

4. **Consider batch automation**
   - Cron job for new plugins
   - Automatic skill generation on plugin addition
   - Integration with CI/CD

## Questions or Issues?

- Check `scripts/CLAUDE_RATE_LIMITS.md` for detailed guide
- Review error messages in database
- Test with single plugin first
- Fall back to Gemini if needed

---

**Last Updated:** 2025-10-18
**Status:** Ready for testing
**Estimated Time to Complete:** 30-60 minutes

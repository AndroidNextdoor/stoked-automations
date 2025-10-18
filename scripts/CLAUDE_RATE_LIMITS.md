# Claude API Rate Limiting Guide

## Current Configuration

The `generate-skills-claude.py` script uses **balanced** rate limiting for optimal throughput and safety:

```python
RATE_LIMIT_DELAY = 30  # 30 seconds between API calls
MAX_RETRIES = 3        # Retry attempts with exponential backoff
RETRY_DELAY = 10       # Base delay: 10s, 20s, 40s
```

## Why 30 Seconds?

Claude API has **generous rate limits** compared to free-tier alternatives:

### Free Tier (API Key without billing)
- **50 requests per day**
- **5 requests per minute (RPM)**
- **10,000 tokens per minute (TPM)**

With 30 second delays:
- ✅ **2 requests per minute** = within 5 RPM limit
- ✅ Safe for small batches (dozens of plugins per day)
- ✅ Prevents hitting daily limit too quickly

### Tier 1 ($5+ spent)
- **1000 RPM**
- **150,000 TPM**
- **2.5M tokens per day**

### Tier 2 ($40+ spent)
- **2000 RPM**
- **400,000 TPM**
- **5M tokens per day**

## Model Selection

**Using:** `claude-sonnet-4-20250514` (Claude Sonnet 4.5)

**Why This Model:**
- High quality output (better than free alternatives)
- Fast generation (sub-5 second responses)
- Excellent instruction following
- Consistent formatting
- 200K context window
- Cost: ~$3 per 1M input tokens, ~$15 per 1M output tokens

**Typical skill generation:**
- Input: ~2000 tokens (plugin context + prompt)
- Output: ~1500 tokens (SKILL.md content)
- Cost per skill: ~$0.03 (3 cents)

## Rate Limit Error Detection

The script automatically detects and handles:
- `429` HTTP status codes (Rate Limit Exceeded)
- `quota` keyword in error messages
- `rate limit` keyword in error messages

## Retry Strategy

**Exponential Backoff:**
1. First retry: Wait 10 seconds
2. Second retry: Wait 20 seconds
3. Third retry: Wait 40 seconds
4. After 3 attempts: Give up and report error

**Total maximum wait per plugin:** 70 seconds (10 + 20 + 40)

## Usage Examples

### Single Plugin
```bash
export ANTHROPIC_API_KEY='sk-ant-...'
python3 scripts/generate-skills-claude.py project-health-auditor
```

**Time estimate:** ~30 seconds
**Cost:** ~$0.03

### Batch of 10 Plugins
```bash
python3 scripts/generate-skills-claude.py plugin1 plugin2 plugin3 ... plugin10
```

**Time estimate:** ~5 minutes (10 × 30 seconds)
**Cost:** ~$0.30 (10 × $0.03)

### Large Batch (50 plugins - free tier daily limit)
```bash
python3 scripts/generate-skills-claude.py $(cat plugin-list.txt)
```

**Time estimate:** ~25 minutes (50 × 30 seconds)
**Cost:** ~$1.50 (50 × $0.03)

## Adjusting Rate Limits

### For Paid Tier 1+ (1000+ RPM)

You can safely reduce the delay to **5-10 seconds**:

```python
RATE_LIMIT_DELAY = 10  # Faster: 10 seconds (6 RPM)
```

### For Free Tier

Keep at **30 seconds** or increase to **60 seconds**:

```python
RATE_LIMIT_DELAY = 60  # Ultra-safe: 60 seconds (1 RPM)
```

## Monitoring Usage

Check your usage and limits at:
- https://console.anthropic.com/settings/usage
- Monitor daily request count
- Check rate tier status
- View token consumption

## Comparing to Alternatives

| Service | Free Tier RPM | Paid Tier RPM | Quality | Cost per Skill |
|---------|---------------|---------------|---------|----------------|
| **Claude** | 5 RPM | 1000-2000 RPM | ⭐⭐⭐⭐⭐ | $0.03 |
| Gemini | 15 RPM | 360 RPM | ⭐⭐⭐ | Free/$0.001 |
| GPT-4 | 5 RPM | 10,000 RPM | ⭐⭐⭐⭐ | $0.06 |

**Winner: Claude** - Best balance of quality, cost, and rate limits.

## Troubleshooting

### Error: "Rate limit exceeded after 3 attempts"

**Solution 1: Wait and retry**
- Rate limits reset every minute
- Wait 1-2 minutes, then retry

**Solution 2: Upgrade tier**
- Free tier: 50 requests/day
- Tier 1: 1000 RPM (need $5+ spent)
- Tier 2: 2000 RPM (need $40+ spent)

**Solution 3: Reduce batch size**
- Process fewer plugins per run
- Split into smaller batches

### Error: "ANTHROPIC_API_KEY environment variable not set"

**Solution:**
```bash
export ANTHROPIC_API_KEY='sk-ant-api03-...'
```

Get your API key at: https://console.anthropic.com/settings/keys

### Error: "Daily request limit reached"

**Free tier limit:** 50 requests per day

**Solutions:**
1. Wait until tomorrow (resets at midnight UTC)
2. Upgrade to paid tier (instant access to 1000+ RPM)
3. Use Gemini script as fallback

## Cost Estimation

### For 231 Total Plugins

**If all needed skills (61 remaining):**
- Time: ~30 minutes (61 × 30s)
- Cost: ~$1.83 (61 × $0.03)

**For current 170 with skills:**
- Already generated (historical cost: ~$5.10)
- No regeneration needed

### Monthly Maintenance

Assuming 10 new plugins per month:
- Time: ~5 minutes per month
- Cost: ~$0.30 per month

## Summary

| Configuration | Value | Reason |
|--------------|-------|--------|
| Delay between calls | 30s | Balanced - safe for free tier, fast enough |
| Max retries | 3 | Reasonable retry attempts |
| Retry backoff | 10s, 20s, 40s | Exponential growth handles temporary limits |
| Model | Claude Sonnet 4.5 | Best quality/cost ratio |
| Free tier RPM | 5 | We use 2 RPM (30s delay) |
| Paid tier RPM | 1000-2000 | Can reduce to 10s delay |
| Cost per skill | $0.03 | Very affordable |

**Key takeaway:** Claude API provides the best quality skills at reasonable cost with good rate limits. The 30-second delay is balanced for both free and paid tiers.

## Migrating from Gemini

If you were using Gemini, switching to Claude gives you:

✅ **Better quality** - Claude follows instructions more precisely
✅ **Faster throughput** - 30s vs 60s delays (2x faster)
✅ **More consistent** - Better formatting adherence
✅ **Higher daily limits** - 50 requests/day (free) vs Gemini's variable quotas
✅ **Better paid tiers** - 1000+ RPM vs 360 RPM

**Migration:**
```bash
# Old (Gemini)
export GEMINI_API_KEY='...'
python3 scripts/generate-skills-gemini.py plugin-name

# New (Claude - recommended)
export ANTHROPIC_API_KEY='sk-ant-...'
python3 scripts/generate-skills-claude.py plugin-name
```

Both scripts remain available for flexibility.

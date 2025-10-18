# Gemini API Rate Limiting Guide

## Current Configuration

The `generate-skills-gemini.py` script uses **ultra-conservative** rate limiting to prevent quota exhaustion:

```python
RATE_LIMIT_DELAY = 60  # 60 seconds between API calls
MAX_RETRIES = 3        # Retry attempts with exponential backoff
RETRY_DELAY = 10       # Base delay: 10s, 20s, 40s
```

## Why 60 Seconds?

Gemini API free tier has strict quota limits:
- **15 requests per minute (RPM)** for free tier
- **1 million tokens per day** for free tier
- **1,500 requests per day** for free tier

With 60 second delays:
- ✅ **1 request per minute** = well under 15 RPM limit
- ✅ Safe for batch operations (dozens of plugins)
- ✅ Prevents hitting daily request limit too quickly
- ✅ Allows retries without exhausting quota

## Quota Error Detection

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
export GEMINI_API_KEY='your-api-key'
python3 scripts/generate-skills-gemini.py project-health-auditor
```

**Time estimate:** ~60 seconds (1 minute)

### Multiple Plugins
```bash
python3 scripts/generate-skills-gemini.py plugin1 plugin2 plugin3 plugin4 plugin5
```

**Time estimate:** ~5 minutes (5 × 60 seconds)

### Batch Generation
For large batches, consider running overnight or in small chunks:

```bash
# Process 10 plugins at a time
python3 scripts/generate-skills-gemini.py plugin1 plugin2 ... plugin10
# Wait 1-2 hours, then run next batch
python3 scripts/generate-skills-gemini.py plugin11 plugin12 ... plugin20
```

## Adjusting Rate Limits

If you have a paid Gemini API tier with higher limits:

1. Edit `scripts/generate-skills-gemini.py`
2. Update the constants:
   ```python
   RATE_LIMIT_DELAY = 30  # Faster: 30 seconds
   MAX_RETRIES = 5        # More retries
   RETRY_DELAY = 5        # Shorter base delay
   ```

**Paid tier limits (as of 2025):**
- 360 RPM (1 request every 0.17 seconds)
- 4 million tokens per day
- 10,000 requests per day

Even with paid tier, we recommend keeping delays at **10-30 seconds** to avoid any quota issues.

## Monitoring Quota Usage

Check your quota usage at:
- https://aistudio.google.com/app/apikey
- Look for "API Key Usage" dashboard
- Monitor requests per minute/day

## Troubleshooting

### Error: "Quota exceeded after 3 attempts"

**Solution 1: Wait and retry**
- Gemini quotas reset every minute
- Wait 2-3 minutes, then retry

**Solution 2: Reduce batch size**
- Process fewer plugins per run
- Split into smaller batches

**Solution 3: Upgrade API tier**
- Free tier: 15 RPM
- Paid tier: 360 RPM

### Error: "Your default credentials were not found"

**This error means:**
- You're using Vertex AI authentication (not Gemini API key)
- The `generate-skills-gemini.py` script requires Gemini API key only

**Solution:**
```bash
export GEMINI_API_KEY='your-gemini-api-key'
```

**NOT needed for this script:**
- `gcloud auth` - Not required
- Vertex AI setup - Not required
- Google Cloud project - Not required

## Alternative: Vertex AI Script

For higher throughput with Google Cloud credentials:

```bash
# Use the Vertex AI script instead
python3 scripts/vertex-skills-generator-safe.py --priority

# Requires:
# - Google Cloud project with Vertex AI enabled
# - gcloud auth application-default login
# - Higher rate limits but requires Cloud billing
```

## Summary

| Configuration | Value | Reason |
|--------------|-------|--------|
| Delay between calls | 60s | Ultra-safe, prevents quota issues |
| Max retries | 3 | Reasonable retry attempts |
| Retry backoff | 10s, 20s, 40s | Exponential growth handles temporary limits |
| Free tier RPM | 15 | We use 1 RPM (60s delay) |
| Paid tier RPM | 360 | Still recommend 10-30s delays |

**Key takeaway:** The 60-second delay is intentionally conservative to ensure reliable batch operations without hitting quota limits.

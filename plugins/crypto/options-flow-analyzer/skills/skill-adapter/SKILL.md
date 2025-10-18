---
name: Analyzing Options Flow
description: |
  Tracks institutional options flow, unusual options activity, and smart money movements through comprehensive flow analysis and gamma exposure calculations. Activates when users mention "options flow", "institutional trading", "unusual options activity", "smart money", "gamma exposure", "options sweeps", "block trades", or "dark pool activity". Provides real-time monitoring of large premium trades, sweep orders, and dealer positioning metrics to identify institutional positioning and potential market-moving events.
---

## Overview

This skill enables comprehensive analysis of institutional options flow to identify smart money movements and unusual trading activity. It monitors large premium trades, sweep orders, block trades, and calculates gamma exposure metrics to reveal institutional positioning and potential market catalysts.

## How It Works

1. **Flow Detection**: Scans for institutional-size trades above configurable premium thresholds ($100K, $500K, $1M+)
2. **Activity Classification**: Categorizes trades as sweeps, blocks, dark pool activity, or retail flow based on execution patterns
3. **Gamma Analysis**: Calculates net dealer gamma exposure, flip points, and max pain levels for hedging insights
4. **Alert Generation**: Provides real-time notifications for unusual volume spikes, large premium trades, and positioning changes

## When to Use This Skill

- When users ask about "options flow" or "institutional options activity"
- When monitoring "smart money" movements or "unusual options activity"
- When analyzing "gamma exposure", "dealer positioning", or "max pain"
- When tracking "options sweeps", "block trades", or "dark pool" activity
- When investigating volume spikes or premium anomalies in options markets
- When users mention specific tickers with options flow context

## Examples

### Example 1: Real-Time Flow Monitoring
User request: "Monitor options flow for SPY and alert me on large institutional trades"

The skill will:
1. Initialize real-time monitoring for SPY with $500K premium threshold
2. Track sweep orders, block trades, and unusual volume patterns
3. Generate alerts for institutional-size trades with flow direction and sentiment analysis

### Example 2: Gamma Exposure Analysis
User request: "What's the gamma situation for TSLA options?"

The skill will:
1. Calculate net dealer gamma exposure across all TSLA strikes and expirations
2. Identify gamma flip points and critical hedging levels
3. Provide max pain calculation and vanna flow analysis for positioning insights

### Example 3: Unusual Activity Detection
User request: "Find unusual options activity in tech stocks today"

The skill will:
1. Scan technology sector tickers for volume spikes above 5x average
2. Identify premium anomalies and new position openings
3. Flag complex spread strategies and institutional positioning changes

## Best Practices

- **Threshold Configuration**: Set appropriate minimum premium levels based on underlying liquidity and typical institutional size
- **Multi-Timeframe Analysis**: Combine real-time alerts with historical flow patterns for context
- **Gamma Awareness**: Monitor gamma exposure during high volatility periods and near major expirations
- **Flow Confirmation**: Cross-reference unusual activity with news, earnings, or technical levels for validation

## Integration

Works seamlessly with market data feeds and trading platforms to provide comprehensive options market intelligence. Integrates with alert systems via webhooks and email notifications. Can be combined with technical analysis tools to correlate options flow with price action and support/resistance levels for enhanced trading insights.
---
name: Analyzing Market Sentiment
description: |
  Analyzes market sentiment by aggregating data from social media platforms, news outlets, and on-chain metrics to gauge market mood and identify trading opportunities. Automatically activates when users mention "sentiment analysis", "market mood", "fear and greed", "social sentiment", "whale activity", or request analysis of market psychology and crowd behavior patterns.
---

## Overview

This skill enables comprehensive market sentiment analysis by combining social media signals, news sentiment, and on-chain data into actionable insights. It processes multiple data sources to calculate sentiment scores, detect trend shifts, and identify contrarian trading opportunities.

## How It Works

1. **Data Aggregation**: Collects sentiment data from Twitter, Reddit, Telegram, news sources, and blockchain analytics
2. **Sentiment Scoring**: Calculates weighted sentiment scores (0-100) and Fear & Greed Index measurements
3. **Signal Generation**: Identifies momentum shifts, contrarian signals, and correlation patterns with price movements

## When to Use This Skill

- User asks about market sentiment or crowd psychology
- Mentions "fear and greed", "market mood", or "sentiment analysis"
- Requests social media sentiment tracking
- Asks about whale activity or on-chain behavior
- Wants to identify contrarian trading opportunities
- Inquires about news impact on market psychology

## Examples

### Example 1: Comprehensive Sentiment Analysis
User request: "What's the current sentiment for Bitcoin?"

The skill will:
1. Execute `/analyze-sentiment BTC` to gather multi-source data
2. Display social media mentions, news sentiment percentage, on-chain metrics, and Fear & Greed Index score with interpretation

### Example 2: Social Media Focus
User request: "Check Twitter sentiment for Ethereum"

The skill will:
1. Run `/social-pulse ETH` to analyze social platforms
2. Show mention volume trends, sentiment polarity, influential account activity, and viral content detection

### Example 3: Fear & Greed Assessment
User request: "Is the market showing fear or greed right now?"

The skill will:
1. Use `/fear-greed` command for current index calculation
2. Provide score interpretation (Extreme Fear 0-25, Fear 25-45, Neutral 45-55, Greed 55-75, Extreme Greed 75-100)

## Best Practices

- **Contrarian Analysis**: Use extreme sentiment readings (below 25 or above 75) as potential reversal signals
- **Multi-Timeframe**: Compare current sentiment with historical averages to identify significant deviations
- **Correlation Tracking**: Monitor how sentiment changes correlate with actual price movements for validation
- **Source Weighting**: Consider the reliability and influence of different data sources in overall assessment

## Integration

Works seamlessly with trading platforms and portfolio management tools to incorporate sentiment data into investment decisions. Can be combined with technical analysis plugins to create comprehensive market assessment frameworks and automated alert systems for significant sentiment shifts.
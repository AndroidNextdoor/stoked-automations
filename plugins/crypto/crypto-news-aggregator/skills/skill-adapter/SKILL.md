---
name: Aggregating Cryptocurrency News with Sentiment Analysis
description: |
  Automatically aggregates cryptocurrency news from 50+ sources including CoinDesk, CoinTelegraph, Twitter/X, Reddit, and official project announcements. Performs AI-powered sentiment analysis, trend detection, and market impact scoring. Activates when users ask about crypto news, market sentiment, breaking crypto developments, trending topics, or need comprehensive crypto market analysis across multiple sources.
---

## Overview
This skill leverages the crypto-news-aggregator plugin to collect and analyze cryptocurrency news from diverse sources in real-time. It provides sentiment analysis, identifies trending topics, and assesses potential market impact to give users comprehensive crypto market intelligence.

## How It Works
1. **Source Monitoring**: Continuously monitors 50+ sources including major crypto publications, social media platforms, exchange announcements, and SEC filings
2. **Content Analysis**: Applies AI-powered sentiment analysis and trend detection algorithms to identify market-moving news and emerging patterns
3. **Impact Assessment**: Scores news items for potential market impact and consolidates findings into actionable intelligence reports

## When to Use This Skill
- When users ask about current crypto news, market sentiment, or breaking developments
- For requests involving crypto trend analysis, market intelligence, or news aggregation
- When users need comprehensive crypto market overview from multiple sources
- For monitoring specific cryptocurrencies or tracking sentiment around particular projects

## Examples

### Example 1: General Market News
User request: "What's the latest crypto news and market sentiment today?"

The skill will:
1. Execute `/aggregate-news` to pull recent articles from all monitored sources
2. Provide sentiment-analyzed news summary with market impact scores and trending topics

### Example 2: Specific Coin Analysis
User request: "Show me recent Bitcoin news and how the market is reacting"

The skill will:
1. Run targeted news aggregation focused on Bitcoin-related content
2. Return filtered results with sentiment analysis and market impact assessment for Bitcoin-specific developments

### Example 3: Breaking News Monitoring
User request: "Any major crypto developments or breaking news I should know about?"

The skill will:
1. Query for high-impact, time-sensitive news items across all sources
2. Prioritize breaking news alerts and significant market-moving announcements with urgency indicators

## Best Practices
- **Source Diversity**: The aggregator pulls from traditional media, social platforms, and official channels for comprehensive coverage
- **Sentiment Context**: Consider sentiment scores alongside traditional market indicators for more nuanced analysis
- **Timing Awareness**: Breaking news and market reactions can evolve rapidly; refresh aggregation for developing stories

## Integration
Works seamlessly with portfolio tracking tools, trading platforms, and market analysis plugins. Can feed aggregated news data into broader investment research workflows or automated alert systems for specific cryptocurrency projects or market conditions.
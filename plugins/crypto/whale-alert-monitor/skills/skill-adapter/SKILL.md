---
name: Monitoring Cryptocurrency Whale Transactions
description: |
  Monitors large cryptocurrency transactions and whale wallet movements in real-time across multiple blockchains including Ethereum, Bitcoin, Binance Smart Chain, and Solana. Activates when users mention "whale tracking", "large crypto transactions", "whale alerts", "monitor whales", "whale activity", "big crypto moves", "whale movements", or "crypto whale analysis". Provides automated alerts through Slack, Discord, Telegram, and email with market impact assessments.
---

## Overview
This skill enables real-time monitoring of cryptocurrency whale transactions across major blockchains. It detects significant wallet movements, analyzes potential market impact, and delivers automated alerts through multiple channels to help users stay informed about major cryptocurrency flows.

## How It Works
1. **Detection**: Scans multiple blockchains for transactions above specified thresholds
2. **Analysis**: Performs wallet clustering analysis and market impact assessment
3. **Alerting**: Sends real-time notifications through configured channels with transaction details

## When to Use This Skill
- Track large cryptocurrency transactions that could impact market prices
- Monitor specific whale wallets for significant movements
- Set up automated alerts for transactions above certain dollar amounts
- Analyze historical whale patterns for trading insights
- Track exchange inflows/outflows from major wallets

## Examples

### Example 1: Real-time Whale Monitoring
User request: "I want to track whale transactions over $10 million on Ethereum"

The skill will:
1. Configure monitoring for Ethereum transactions exceeding $10M threshold
2. Provide real-time alerts with transaction hash, wallet addresses, and market impact analysis

### Example 2: Exchange Whale Tracking
User request: "Monitor large Bitcoin withdrawals from major exchanges"

The skill will:
1. Set up tracking for significant Bitcoin outflows from known exchange wallets
2. Alert on movements that could indicate market sentiment changes or institutional activity

### Example 3: Multi-Chain Whale Analysis
User request: "Track whale activity across all supported blockchains"

The skill will:
1. Enable comprehensive monitoring across Ethereum, Bitcoin, BSC, Polygon, Arbitrum, Optimism, Avalanche, and Solana
2. Provide consolidated alerts with cross-chain whale movement patterns

## Best Practices
- **Threshold Setting**: Start with higher dollar amounts ($5M+) to avoid alert fatigue from smaller transactions
- **Channel Configuration**: Set up multiple alert channels for redundancy and different notification preferences
- **Historical Analysis**: Review whale patterns before major market events to identify recurring behaviors
- **Wallet Clustering**: Use the clustering analysis to identify connected wallets and track coordinated movements

## Integration
Works seamlessly with trading platforms and portfolio management tools. Alerts can be configured to integrate with existing workflow automation tools like Zapier or custom webhooks. Historical data can be exported for further analysis in spreadsheet applications or data visualization tools.
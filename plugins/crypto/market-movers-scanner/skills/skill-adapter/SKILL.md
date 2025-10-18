---
name: Scanning Market Movers
description: |
  Automatically scans for top market movers including gainers, losers, volume spikes, and unusual activity across crypto, stocks, and forex markets. Activates when users request market scanning, want to find top performers, identify trading opportunities, monitor volume leaders, detect breakouts, or track unusual market activity. Provides real-time updates with customizable filters and alerts.
---

## Overview

This skill enables Claude Code to perform comprehensive market scanning across multiple asset classes. It identifies top gainers, losers, volume leaders, and unusual trading activity in real-time, helping users discover trading opportunities and monitor market movements efficiently.

## How It Works

1. **Market Selection**: Automatically determines target markets (crypto, stocks, forex) based on user context or scans all markets by default
2. **Data Aggregation**: Pulls real-time price and volume data from multiple sources with 30-second refresh intervals  
3. **Analysis & Filtering**: Applies intelligent filters to identify significant movers while excluding noise and low-quality assets
4. **Results Display**: Presents organized results with performance metrics, volume data, and visual indicators
5. **Continuous Monitoring**: Maintains real-time updates with alert notifications for extreme movements

## When to Use This Skill

- User asks to "scan the markets", "find market movers", or "what's moving today"
- Requests for top gainers, losers, or volume leaders across any timeframe
- Questions about unusual trading activity, breakouts, or volatility spikes  
- Need to identify trading opportunities or oversold/overbought conditions
- Monitoring specific market segments like crypto, stocks, or forex
- Setting up alerts for extreme price movements or volume anomalies

## Examples

### Example 1: General Market Scan
User request: "Scan for today's top market movers"

The skill will:
1. Execute `/scan-movers` command with default 24h timeframe
2. Display top 20 gainers, losers, and volume leaders across all markets
3. Highlight any extreme movements exceeding alert thresholds
4. Provide performance percentages, volume data, and market context

### Example 2: Crypto-Focused Analysis
User request: "Show me the biggest crypto movers this week"

The skill will:
1. Run `/scan-movers crypto` with 7-day timeframe filter
2. Apply crypto-specific filters excluding stablecoins and low-cap assets
3. Present results with market cap data, trading pairs, and exchange information
4. Include breakout detection and unusual activity alerts

### Example 3: Real-Time Monitoring
User request: "Monitor the markets for any big moves"

The skill will:
1. Activate `/monitor-movers` for continuous scanning
2. Set up real-time alerts for movements exceeding 10% gains/losses
3. Display live updating dashboard with 30-second refresh intervals
4. Send notifications for critical market events or extreme volatility

## Best Practices

- **Market Context**: Always consider current market conditions and trading hours when interpreting results
- **Filter Application**: Use appropriate filters to exclude low-quality assets and focus on liquid, tradeable securities
- **Timeframe Selection**: Match scanning timeframes to user's trading style and objectives
- **Volume Validation**: Verify significant price movements are supported by adequate trading volume
- **Alert Management**: Configure alert thresholds based on market volatility and user risk tolerance

## Integration

Works seamlessly with portfolio management tools for position analysis, trading platforms for order execution, and technical analysis plugins for deeper chart examination. Results can be exported to spreadsheets, integrated with backtesting systems, or used to populate watchlists in trading applications. The real-time data feeds complement other market analysis tools and can trigger automated trading strategies when combined with appropriate risk management systems.
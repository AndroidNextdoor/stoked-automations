---
name: Tracking Market Prices
description: |
  Monitors real-time market prices across cryptocurrencies, stocks, forex, and commodities using multi-exchange data feeds with advanced analytics and alerts. Activates when users mention "track price", "monitor market", "watch crypto", "price alerts", "real-time quotes", "market data", or need live trading information with technical analysis and pattern recognition.
---

## Overview

This skill enables comprehensive real-time market price tracking across multiple asset classes including cryptocurrencies, stocks, forex, and commodities. It aggregates data from multiple exchanges and sources to provide accurate, low-latency price feeds with advanced technical analysis, pattern recognition, and intelligent alerting systems.

## How It Works

1. **Multi-Source Data Aggregation**: Connects to multiple exchanges (Binance, Coinbase, Kraken) and data providers (Alpha Vantage, IEX Cloud, OANDA) via WebSocket streams for sub-second price updates
2. **Price Analysis & Validation**: Calculates VWAP, median pricing, and confidence scores across sources while monitoring for anomalies and feed quality
3. **Technical Analysis Engine**: Applies indicators (RSI, MACD, Bollinger Bands), detects chart patterns, and identifies support/resistance levels in real-time
4. **Alert Management**: Monitors custom conditions (price thresholds, volume spikes, pattern completions) with intelligent cooldowns and multi-channel notifications

## When to Use This Skill

- User wants to monitor real-time prices for trading decisions
- Need to set up price alerts above/below specific thresholds
- Tracking cryptocurrency portfolio performance across exchanges
- Analyzing stock price movements with technical indicators
- Monitoring forex pairs for currency trading opportunities
- Detecting unusual market activity or volatility spikes
- Comparing prices across multiple exchanges or data sources
- Setting up automated market surveillance systems

## Examples

### Example 1: Cryptocurrency Price Monitoring
User request: "Track BTC price in real-time with alerts when it goes above $50,000"

The skill will:
1. Connect to multiple crypto exchanges (Binance, Coinbase, Kraken) via WebSocket
2. Aggregate BTC/USDT prices using VWAP methodology
3. Display live price updates with exchange-specific data and confidence scores
4. Monitor for $50,000 threshold and trigger alerts when reached
5. Show technical indicators (RSI, MACD) and recent trading volume

### Example 2: Stock Market Analysis
User request: "Monitor AAPL stock with technical analysis on 4-hour timeframe"

The skill will:
1. Connect to stock data feeds (Alpha Vantage, IEX Cloud) for Apple stock
2. Display real-time price with day's high/low, volume, and market cap
3. Apply technical indicators on 4-hour charts (Bollinger Bands, RSI, moving averages)
4. Detect chart patterns and identify key support/resistance levels
5. Provide trend analysis with momentum indicators and trading signals

### Example 3: Multi-Asset Portfolio Tracking
User request: "Watch my portfolio: BTC, ETH, AAPL, EUR/USD with volatility alerts"

The skill will:
1. Set up simultaneous tracking for crypto, stock, and forex assets
2. Create a unified dashboard showing all positions with percentage changes
3. Monitor volatility using ATR (Average True Range) across all assets
4. Generate alerts when any asset experiences unusual price movements
5. Provide correlation analysis between different asset classes

## Best Practices

- **Exchange Selection**: Use primary exchanges (Binance, Coinbase for crypto; major markets for stocks) with fallback sources for reliability
- **Alert Configuration**: Set reasonable cooldown periods (5-15 minutes) to avoid notification spam during volatile periods
- **Timeframe Optimization**: Match analysis timeframes to trading strategy (1s-1m for scalping, 4h-1d for swing trading)
- **Data Quality Monitoring**: Always check confidence scores and source availability before making trading decisions
- **Risk Management**: Combine price alerts with volume analysis to filter out low-liquidity price spikes

## Integration

Works seamlessly with portfolio management tools, trading platforms, and notification systems. Integrates with webhook endpoints for custom alert routing, supports export to CSV/JSON for further analysis, and can feed data to automated trading systems. Compatible with popular exchanges' APIs and traditional financial data providers for comprehensive market coverage.
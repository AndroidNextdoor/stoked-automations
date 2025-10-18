---
name: Tracking Cryptocurrency Portfolios
description: |
  Analyzes cryptocurrency portfolios with real-time price tracking, profit/loss calculations, risk metrics, and rebalancing recommendations. Activates when users mention "crypto portfolio", "track crypto positions", "bitcoin portfolio", "crypto PnL", "portfolio analysis", "crypto rebalancing", "risk metrics", or want to monitor cryptocurrency investments with professional-grade analytics.
---

## Overview

This skill enables professional cryptocurrency portfolio management through real-time position tracking, comprehensive risk analysis, and optimization recommendations. It provides institutional-quality metrics including Sharpe ratios, correlation analysis, and automated rebalancing suggestions for crypto investors.

## How It Works

1. **Position Tracking**: Records cryptocurrency positions with entry prices, quantities, and dates while fetching real-time prices from multiple exchanges
2. **Risk Analysis**: Calculates advanced metrics including volatility, maximum drawdown, Value at Risk, and correlation matrices
3. **Portfolio Optimization**: Generates rebalancing recommendations using Modern Portfolio Theory and provides tax-aware trading suggestions

## When to Use This Skill

- User wants to track crypto positions or mentions "crypto portfolio"
- Requests for Bitcoin, Ethereum, or altcoin portfolio analysis
- Needs profit/loss calculations or performance metrics
- Asks about crypto risk management or diversification
- Wants rebalancing recommendations or allocation optimization
- Mentions crypto alerts, stop losses, or price monitoring
- Seeks correlation analysis between crypto assets

## Examples

### Example 1: New Position Tracking
User request: "I bought 0.5 BTC at $45,000 yesterday, can you track this position?"

The skill will:
1. Create a new position entry with BTC symbol, 0.5 quantity, $45,000 entry price
2. Fetch current BTC price and calculate unrealized PnL
3. Set up real-time monitoring with configurable alerts
4. Add position to portfolio analysis and risk calculations

### Example 2: Portfolio Risk Analysis
User request: "Analyze my crypto portfolio risk and show me diversification metrics"

The skill will:
1. Calculate Sharpe ratio, Sortino ratio, and maximum drawdown for the entire portfolio
2. Generate correlation matrix between held cryptocurrencies
3. Compute Herfindahl Index for concentration analysis
4. Provide Value at Risk calculations at 95% and 99% confidence levels
5. Recommend optimal allocation adjustments

### Example 3: Rebalancing Recommendations
User request: "My portfolio is too heavy in Bitcoin, suggest rebalancing"

The skill will:
1. Analyze current allocation percentages across all positions
2. Calculate optimal portfolio weights using risk-return optimization
3. Generate specific buy/sell recommendations with quantities
4. Estimate transaction costs and tax implications
5. Provide threshold-based or time-based rebalancing strategy

## Best Practices

- **Position Entry**: Always record complete position data including entry date, price, and quantity for accurate PnL calculations
- **Risk Management**: Set appropriate stop-loss levels and position size limits based on portfolio risk tolerance
- **Diversification**: Monitor correlation coefficients to avoid over-concentration in similar assets
- **Alert Configuration**: Establish meaningful price and volatility alerts to capture significant market movements
- **Regular Analysis**: Perform comprehensive portfolio reviews monthly or after major market events

## Integration

Works seamlessly with trading platforms and tax software through data export capabilities. Integrates with price feeds from CoinGecko, Binance, and Coinbase for accurate multi-source pricing. Compatible with portfolio management tools and can generate reports for tax preparation and regulatory compliance.
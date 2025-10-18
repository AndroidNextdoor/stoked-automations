---
name: Tracking Crypto Derivatives Markets
description: |
  Analyzes cryptocurrency futures, options, and perpetual swaps with real-time funding rates, open interest tracking, and derivatives market intelligence. Activates when users mention funding rates, perpetuals, futures basis, options flow, liquidations, open interest, derivatives trading, contango/backwardation, or specific terms like "perps", "funding", "OI", "basis trading", "Greeks", or "liquidation levels".
---

## Overview

This skill provides comprehensive analysis of cryptocurrency derivatives markets, tracking perpetual swaps, futures contracts, and options across major exchanges. It monitors funding rates, open interest changes, liquidation levels, and identifies trading opportunities through basis analysis and market sentiment indicators.

## How It Works

1. **Market Data Collection**: Aggregates real-time data from Binance, Bybit, OKX, Deribit, and other major derivatives exchanges
2. **Metrics Analysis**: Calculates funding rates, open interest changes, basis spreads, and options Greeks
3. **Signal Generation**: Identifies trading opportunities through funding extremes, OI divergence, and liquidation cascade patterns
4. **Risk Assessment**: Evaluates market leverage ratios and potential liquidation zones

## When to Use This Skill

- Analyzing perpetual swap funding rates and long/short ratios
- Tracking open interest changes across futures contracts
- Evaluating options flow and volatility patterns
- Identifying basis trading opportunities between spot and futures
- Monitoring liquidation levels and cascade risks
- Comparing derivatives metrics across multiple exchanges
- Assessing market sentiment through derivatives data

## Examples

### Example 1: Funding Rate Analysis
User request: "What's the current funding rate for BTC perpetuals across exchanges?"

The skill will:
1. Query funding rates from Binance, Bybit, OKX, and other exchanges
2. Display current 8-hour funding rates and annualized percentages
3. Highlight exchanges with extreme rates for potential arbitrage
4. Show historical funding trends and sentiment indicators

### Example 2: Open Interest Monitoring
User request: "Show me BTC futures open interest and any significant changes"

The skill will:
1. Retrieve current open interest across all BTC futures contracts
2. Calculate percentage changes over 24h, 7d, and 30d periods
3. Analyze OI vs price correlation for trend strength assessment
4. Identify unusual OI spikes or liquidation events

### Example 3: Options Flow Analysis
User request: "Analyze ETH options activity for this week's expiry"

The skill will:
1. Pull options volume and open interest by strike and expiry
2. Calculate put/call ratios and implied volatility levels
3. Display maximum pain levels and gamma exposure
4. Show unusual options flow and institutional positioning

### Example 4: Basis Trading Opportunity
User request: "Is there a basis trading opportunity for SOL futures?"

The skill will:
1. Compare spot prices with futures prices across different expiries
2. Calculate annualized basis and funding equivalent rates
3. Assess carry trade profitability after borrowing costs
4. Highlight contango/backwardation patterns

## Best Practices

- **Funding Extremes**: Rates above ±0.1% (8-hour) often signal contrarian opportunities
- **OI Divergence**: Rising OI with opposite price movement indicates strong directional conviction
- **Multi-Exchange**: Always compare metrics across exchanges for arbitrage opportunities
- **Risk Management**: Monitor liquidation clusters as potential support/resistance levels
- **Options Greeks**: Use delta-neutral strategies when volatility is mispriced

## Integration

Works seamlessly with trading platforms and portfolio management tools. Data can be exported for backtesting strategies or integrated with alert systems for funding rate thresholds. Compatible with DeFi protocols like dYdX and GMX for decentralized derivatives analysis.
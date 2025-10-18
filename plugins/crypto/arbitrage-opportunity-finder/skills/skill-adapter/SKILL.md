---
name: Finding Arbitrage Trading Opportunities
description: |
  Scans centralized exchanges (CEX), decentralized exchanges (DEX), and cross-chain protocols to identify profitable arbitrage opportunities. Activates when users mention "arbitrage", "price differences", "trading opportunities", "CEX/DEX spreads", "cross-chain arbitrage", "triangular arbitrage", "flash loans", "MEV opportunities", or ask to "find profitable trades", "scan for arbitrage", "compare prices across exchanges", or "monitor spreads". Provides real-time detection, profit calculations, gas cost analysis, and execution strategies for various arbitrage types including simple arbitrage, triangular arbitrage, and funding rate differentials.
---

## Overview

This skill automatically detects and analyzes arbitrage opportunities across multiple trading venues including centralized exchanges, DeFi protocols, and cross-chain bridges. It calculates profitability after accounting for fees, gas costs, and execution risks.

## How It Works

1. **Market Scanning**: Continuously monitors price feeds from major CEXs (Binance, Coinbase, Kraken) and DEXs (Uniswap, SushiSwap, PancakeSwap)
2. **Opportunity Detection**: Identifies price discrepancies exceeding minimum profit thresholds across different trading pairs and venues
3. **Profitability Analysis**: Calculates net profit after deducting trading fees, gas costs, slippage, and bridge fees for cross-chain opportunities
4. **Risk Assessment**: Evaluates execution risk, liquidity depth, and time-sensitive factors that could impact profitability

## When to Use This Skill

- When users ask about "arbitrage opportunities" or "price differences between exchanges"
- When mentioned "CEX/DEX arbitrage", "cross-chain opportunities", or "triangular arbitrage"
- When users want to "find profitable trades", "scan markets", or "monitor spreads"
- When discussing "flash loan arbitrage", "MEV opportunities", or "DeFi yield farming arbitrage"
- When users need "real-time trading alerts" or "automated opportunity detection"

## Examples

### Example 1: Simple CEX Arbitrage
User request: "Find arbitrage opportunities between Binance and Coinbase for ETH"

The skill will:
1. Execute `/find-arbitrage --exchanges binance,coinbase --token ETH`
2. Display price differences, required capital, and net profit calculations
3. Provide execution steps and timing recommendations

### Example 2: DEX Triangular Arbitrage
User request: "Look for triangular arbitrage on Uniswap with USDC, ETH, and WBTC"

The skill will:
1. Run `/find-arbitrage --type triangular --tokens USDC,ETH,WBTC --dex uniswap`
2. Map circular trading paths and calculate optimal trade sizes
3. Estimate gas costs and provide flash loan execution strategy

### Example 3: Cross-Chain Opportunity
User request: "Monitor cross-chain arbitrage between Ethereum and Polygon"

The skill will:
1. Execute `/monitor-spreads --chains ethereum,polygon --bridges polygon-bridge`
2. Track price differentials accounting for bridge fees and time delays
3. Alert when opportunities exceed minimum profit thresholds

### Example 4: Funding Rate Arbitrage
User request: "Find funding rate arbitrage opportunities"

The skill will:
1. Scan perpetual futures funding rates across exchanges
2. Identify negative funding rates for potential profit
3. Calculate holding period returns and execution requirements

## Best Practices

- **Capital Efficiency**: Prioritize flash loan opportunities to minimize capital requirements
- **Gas Optimization**: Monitor network congestion and adjust profit thresholds accordingly
- **Slippage Management**: Verify liquidity depth before executing large trades
- **Timing Sensitivity**: Execute quickly as arbitrage windows close rapidly
- **Risk Management**: Set stop-loss levels and maximum exposure limits per opportunity

## Integration

Works seamlessly with portfolio management plugins for capital allocation, wallet plugins for multi-chain execution, and alert systems for real-time notifications. Integrates with trading bots for automated execution and risk management tools for position sizing. Compatible with tax tracking plugins to record arbitrage profits and DeFi analytics tools for yield optimization strategies.
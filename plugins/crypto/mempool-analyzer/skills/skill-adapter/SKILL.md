---
name: Analyzing Blockchain Mempools for MEV Opportunities
description: |
  Monitors pending blockchain transactions across Ethereum, BSC, Polygon, and Arbitrum to identify MEV opportunities, optimize gas pricing, and analyze transaction patterns. Activates when users mention mempool analysis, MEV extraction, sandwich attacks, arbitrage opportunities, gas optimization, pending transactions, front-running detection, or large transfer monitoring. Provides real-time insights into blockchain transaction flows and profit extraction strategies.
---

## Overview

This skill enables real-time mempool analysis to identify MEV (Maximal Extractable Value) opportunities and monitor pending transactions across major blockchain networks. It automatically detects profitable arbitrage, sandwich attacks, and liquidation opportunities while providing gas price optimization recommendations.

## How It Works

1. **Network Monitoring**: Connects to multiple blockchain networks via RPC endpoints to stream pending transactions in real-time
2. **Transaction Classification**: Analyzes transaction calldata to identify swaps, transfers, and contract interactions with profit potential
3. **MEV Detection**: Applies algorithms to detect sandwich opportunities, arbitrage across DEXs, and liquidation scenarios
4. **Risk Assessment**: Evaluates gas costs, competition levels, and profit margins for identified opportunities
5. **Optimization**: Provides gas price recommendations and timing strategies for transaction execution

## When to Use This Skill

- Analyzing pending transactions for MEV opportunities
- Monitoring mempool for large transfers or suspicious activity
- Optimizing gas prices for transaction timing
- Detecting sandwich attacks or front-running attempts
- Finding arbitrage opportunities across decentralized exchanges
- Tracking specific addresses for incoming transactions
- Understanding block builder MEV extraction patterns
- Researching transaction flows and market dynamics

## Examples

### Example 1: MEV Opportunity Detection
User request: "What MEV opportunities are currently available in the Ethereum mempool?"

The skill will:
1. Scan pending transactions across Ethereum mempool
2. Identify potential sandwich attacks on large DEX swaps
3. Calculate arbitrage opportunities between Uniswap and SushiSwap
4. Present opportunities with profit estimates and risk assessments

### Example 2: Large Transaction Monitoring
User request: "Monitor for any pending ETH transfers over $1 million"

The skill will:
1. Filter mempool transactions by value threshold
2. Track large ETH transfers and display sender/recipient details
3. Provide real-time alerts when qualifying transactions appear
4. Analyze transaction patterns and potential market impact

### Example 3: Gas Price Optimization
User request: "What's the optimal gas price for my transaction to be included in the next block?"

The skill will:
1. Analyze current mempool congestion and pending transaction gas prices
2. Examine EIP-1559 base fee trends and prediction models
3. Calculate optimal gas price based on urgency requirements
4. Provide timing recommendations for cost-effective execution

## Best Practices

- **Risk Management**: Always assess gas costs against potential profits, as MEV extraction is highly competitive
- **Network Selection**: Choose appropriate networks based on gas costs and opportunity size
- **Timing Considerations**: Monitor block builder patterns and validator preferences for optimal execution
- **Compliance**: Be aware of regulatory implications and focus on defensive MEV strategies
- **Configuration**: Properly configure RPC endpoints and API keys for reliable data access

## Integration

This skill works seamlessly with trading bots, DeFi protocols, and blockchain analytics tools. It can feed data to automated trading systems, provide alerts to portfolio management applications, and integrate with risk management frameworks. The mempool insights enhance decision-making for traders, researchers, and protocol developers working in the MEV ecosystem.
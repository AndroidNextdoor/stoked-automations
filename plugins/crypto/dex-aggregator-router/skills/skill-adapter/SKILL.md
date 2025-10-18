---
name: Finding Optimal DEX Routes for Token Swaps
description: |
  Activates when users mention token swaps, DEX routing, finding best rates, comparing exchanges, or optimizing trades. Analyzes routes across multiple decentralized exchanges like Uniswap, SushiSwap, Curve, and aggregators like 1inch to find optimal paths that maximize output while minimizing costs and slippage. Considers direct routes, multi-hop paths, split orders, gas costs, and price impact to recommend the best trading strategy.
---

## Overview

This skill automatically finds optimal routing for token swaps across decentralized exchanges. It analyzes multiple DEXs simultaneously to identify the best trade execution path, considering factors like price impact, gas costs, liquidity depth, and slippage tolerance.

## How It Works

1. **Route Discovery**: Scans direct swaps, multi-hop paths through intermediate tokens, and split order opportunities across major DEXs
2. **Cost Analysis**: Calculates total costs including price impact, slippage, and gas fees for each potential route
3. **Optimization**: Recommends the route that maximizes net output after all costs, with execution parameters and risk considerations

## When to Use This Skill

- Asking about token swap routes or best rates between cryptocurrencies
- Comparing prices across different DEXs like "Uniswap vs SushiSwap"
- Mentioning trade optimization, routing, or aggregator services
- Questions about slippage, price impact, or large trade execution
- References to 1inch, Paraswap, Matcha, or other DEX aggregators
- Discussing multi-hop swaps or intermediate token paths

## Examples

### Example 1: Simple Route Optimization
User request: "What's the best route to swap 10 ETH for USDC?"

The skill will:
1. Analyze direct ETH→USDC routes across Uniswap V2/V3, SushiSwap, Curve, and major aggregators
2. Present a comparison table showing rates, price impact, gas costs, and net USDC received for each option
3. Recommend the optimal route with specific execution parameters and slippage settings

### Example 2: Large Trade Analysis
User request: "I want to swap $50,000 USDT to ETH - how should I optimize this?"

The skill will:
1. Evaluate split routing strategies across multiple DEXs to minimize price impact
2. Analyze MEV protection options and recommend batch auction services if beneficial
3. Provide execution timeline suggestions and slippage tolerance recommendations for whale-sized trades

### Example 3: Multi-hop Route Discovery
User request: "Should I swap LINK → ETH → USDC or go LINK → USDC directly?"

The skill will:
1. Calculate both direct LINK→USDC routes and multi-hop paths through ETH
2. Compare total costs including two transaction fees for the multi-hop route
3. Determine which path yields more USDC after accounting for gas costs and price impact

## Best Practices

- **Trade Size Considerations**: Recommends simple routes for small trades, aggregators for medium trades, and split routing for large positions
- **Gas Optimization**: Factors current network congestion and suggests optimal execution timing
- **Risk Management**: Highlights MEV exposure for large trades and suggests protection mechanisms
- **Liquidity Analysis**: Considers pool depths and warns about potential slippage in thin markets

## Integration

Works alongside portfolio tracking and DeFi analysis tools to provide comprehensive trading recommendations. Integrates with gas fee monitoring to suggest optimal transaction timing and connects with yield farming plugins for users considering LP provision as an alternative to direct swaps.
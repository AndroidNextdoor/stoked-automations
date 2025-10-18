---
name: Simulating Flash Loan Strategies
description: |
  Automatically simulates and analyzes flash loan strategies including arbitrage opportunities, liquidations, and collateral swaps across major DeFi protocols like Aave V3, dYdX, Balancer, and Uniswap V3. Activates when users discuss flash loan strategies, DeFi arbitrage, liquidation opportunities, collateral swaps, multi-protocol transactions, or profitability analysis. Calculates optimal loan amounts, estimates gas costs, assesses execution risks, and provides comprehensive risk warnings for educational purposes.
---

## Overview

This skill enables simulation and analysis of complex flash loan strategies across multiple DeFi protocols. It automatically activates when users discuss flash loans, arbitrage opportunities, or multi-protocol DeFi transactions, providing detailed profitability analysis and risk assessment.

## How It Works

1. **Strategy Detection**: Recognizes flash loan scenarios and identifies optimal protocols
2. **Simulation Engine**: Models multi-step transactions with real-time data
3. **Profitability Analysis**: Calculates net profit after fees, gas, and slippage
4. **Risk Assessment**: Evaluates execution risks and competition factors

## When to Use This Skill

- Analyzing arbitrage opportunities between DEXes
- Simulating liquidation strategies on lending protocols  
- Planning collateral swaps and debt refinancing
- Calculating optimal flash loan amounts
- Evaluating multi-protocol transaction sequences
- Backtesting strategies against historical data

## Examples

### Example 1: DEX Arbitrage Simulation
User request: "Simulate a flash loan arbitrage between Uniswap and SushiSwap for ETH"

The skill will:
1. Fetch current prices from both DEXes
2. Calculate optimal flash loan amount from Aave V3
3. Simulate buy/sell sequence and estimate gas costs
4. Provide net profitability analysis with risk warnings

### Example 2: Liquidation Strategy Analysis
User request: "Calculate profitability of liquidating this undercollateralized Aave position"

The skill will:
1. Analyze the position's health factor and collateral
2. Simulate flash loan to acquire liquidation assets
3. Calculate liquidation bonus and transaction costs
4. Determine if liquidation is profitable after all fees

### Example 3: Collateral Swap Planning
User request: "Build a flash loan strategy to swap USDC collateral to ETH on Aave"

The skill will:
1. Design multi-step transaction sequence
2. Calculate temporary flash loan requirements
3. Estimate swap slippage and protocol fees
4. Provide complete transaction flow with gas optimization

## Best Practices

- **Risk First**: Always emphasizes educational purpose and smart contract audit requirements
- **Real Data**: Uses current protocol fees, gas prices, and market conditions
- **Competition Aware**: Warns about MEV bot front-running and timing risks
- **Cost Comprehensive**: Includes all fees (protocol, gas, slippage) in profit calculations
- **Protocol Specific**: Tailors strategies to each protocol's unique features and limitations

## Integration

Works seamlessly with blockchain data providers for real-time pricing, integrates with simulation tools like Tenderly and Foundry, and connects with gas estimation services. Supports configuration through `.flashloan-config.json` for personalized protocol preferences and risk parameters.
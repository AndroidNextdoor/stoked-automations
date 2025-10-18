---
name: Optimizing DeFi Yield Strategies
description: |
  Analyzes and optimizes DeFi yield farming strategies across multiple protocols and chains. Automatically triggers when users mention yield farming optimization, DeFi APY comparison, portfolio rebalancing, risk-adjusted returns, or yield strategy analysis. Provides comprehensive protocol analysis including Aave, Compound, Uniswap, Curve, Yearn, and other major DeFi platforms with risk assessment and auto-compound calculations.
---

## Overview

This skill helps optimize DeFi yield farming strategies by analyzing opportunities across multiple protocols, chains, and risk profiles. It automatically activates the defi-yield-optimizer plugin to provide comprehensive yield analysis, risk assessment, and portfolio allocation recommendations.

## How It Works

1. **Protocol Analysis**: Scans major DeFi protocols across Ethereum, BSC, Polygon, Arbitrum, Avalanche, and Fantom for current APY rates and opportunities
2. **Risk Assessment**: Evaluates protocol risk, smart contract risk, liquidity risk, and impermanent loss potential for each opportunity
3. **Portfolio Optimization**: Calculates optimal allocation strategies based on risk tolerance, capital amount, and time horizon
4. **Gas Cost Analysis**: Factors in transaction costs to determine net APY and optimization frequency
5. **Strategy Recommendation**: Provides actionable recommendations with specific protocols, allocations, and rebalancing schedules

## When to Use This Skill

- User asks about "optimizing yield farming strategies" or "DeFi yield optimization"
- Mentions comparing APY rates across protocols like "Aave vs Compound rates"
- Requests "portfolio rebalancing" or "diversifying DeFi positions"
- Asks about "risk-adjusted returns" or "yield farming risk assessment"
- Mentions "auto-compounding strategies" or "compound frequency optimization"
- Discusses "impermanent loss calculation" or "LP farming analysis"
- Requests analysis of specific protocols or chains for yield opportunities

## Examples

### Example 1: Basic Yield Optimization
User request: "I have $25,000 to deploy in DeFi yield farming with medium risk tolerance"

The skill will:
1. Analyze current yields across major protocols on multiple chains
2. Calculate risk-adjusted returns for lending, LP farming, and yield aggregators
3. Recommend optimal allocation (e.g., 40% Aave lending, 35% Curve LP, 25% Yearn vaults)
4. Provide expected APY range and rebalancing schedule

### Example 2: Protocol Comparison
User request: "Compare stablecoin yields on Ethereum vs Polygon for $50K investment"

The skill will:
1. Fetch current rates from Aave, Compound, Curve on both chains
2. Calculate net yields after gas costs and bridge fees
3. Analyze TVL, protocol risk scores, and historical performance
4. Recommend chain selection based on capital efficiency

### Example 3: Risk Assessment
User request: "Analyze the risks of farming on new BSC protocols with high APY"

The skill will:
1. Evaluate protocol age, audit status, and TVL metrics
2. Calculate smart contract complexity and composability risks
3. Assess liquidity depth and exit strategy options
4. Provide risk-adjusted APY recommendations with safety ratings

## Best Practices

- **Capital Allocation**: Never recommend putting more than 30% of capital in a single protocol to maintain diversification
- **Risk Management**: Always factor protocol age, audit history, and TVL when assessing opportunities above 20% APY
- **Gas Optimization**: Consider transaction costs in yield calculations, especially for smaller amounts on Ethereum
- **Rebalancing Frequency**: Balance compound gains against gas costs when determining optimal rebalancing schedules
- **Chain Selection**: Recommend lower-fee chains (Polygon, BSC) for smaller capital amounts and frequent rebalancing

## Integration

This skill integrates with portfolio management tools and DeFi analytics platforms. It works alongside risk management plugins to provide comprehensive investment analysis. The optimization recommendations can be exported to portfolio trackers or automated execution platforms. Results include actionable transaction details and monitoring schedules for ongoing yield optimization.
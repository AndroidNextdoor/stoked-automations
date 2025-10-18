---
name: Tracking Crypto Wallet Portfolios
description: |
  Tracks cryptocurrency wallets across multiple blockchain networks including Ethereum, BSC, Polygon, Arbitrum, and Avalanche. Provides comprehensive portfolio analytics, DeFi position monitoring, NFT collection tracking, transaction history analysis, and real-time balance updates. Activates when users mention wallet addresses, portfolio tracking, DeFi positions, crypto balances, blockchain analysis, or multi-chain monitoring. Ideal for investors, traders, and portfolio managers requiring institutional-grade cryptocurrency portfolio visibility and analytics across decentralized finance protocols.
---

## Overview

This skill enables comprehensive cryptocurrency wallet portfolio tracking across multiple blockchain networks. It automatically analyzes wallet addresses to provide real-time balances, DeFi positions, transaction history, and portfolio analytics with support for major chains and protocols.

## How It Works

1. **Address Detection**: Automatically recognizes cryptocurrency wallet addresses and determines optimal blockchain networks to scan
2. **Multi-Chain Analysis**: Simultaneously queries Ethereum, BSC, Polygon, Arbitrum, and Avalanche for complete portfolio visibility
3. **Portfolio Aggregation**: Consolidates token balances, DeFi positions, NFT holdings, and transaction data into unified analytics dashboard

## When to Use This Skill

- User provides wallet addresses starting with "0x" for analysis
- Requests for "portfolio tracking", "wallet analysis", or "crypto balances"
- Mentions "DeFi positions", "yield farming", or "liquidity pools"
- Asks about "multi-chain" or "cross-chain" portfolio monitoring
- Needs "transaction history" or "blockchain analysis"
- Requests "whale watching" or monitoring large wallet movements

## Examples

### Example 1: Complete Wallet Analysis
User request: "Analyze this wallet 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1"

The skill will:
1. Scan the address across all supported chains (Ethereum, BSC, Polygon, Arbitrum, Avalanche)
2. Display total portfolio value, token distribution, DeFi positions, and NFT collections
3. Provide asset allocation percentages and risk assessment metrics

### Example 2: DeFi Position Monitoring
User request: "Show me the DeFi positions for this address"

The skill will:
1. Query lending protocols (Aave, Compound, MakerDAO), DEXs (Uniswap, SushiSwap), and yield farms
2. Calculate total value locked, current APY, and impermanent loss exposure
3. Present protocol-specific holdings with yield farming rewards and staking positions

### Example 3: Transaction History Analysis
User request: "Get transaction history and gas usage for my wallet"

The skill will:
1. Retrieve comprehensive transaction history across all chains with categorization
2. Analyze gas optimization opportunities and fee tracking
3. Identify interaction patterns and provide insights on transaction efficiency

## Best Practices

- **Address Validation**: Always verify wallet addresses are properly formatted before analysis
- **Chain Selection**: Automatically scan all supported chains unless user specifies particular networks
- **Real-Time Updates**: Refresh portfolio data for active monitoring and alert notifications
- **Privacy Awareness**: Handle wallet addresses securely and remind users about privacy implications
- **Risk Assessment**: Include concentration risk analysis and protocol exposure warnings

## Integration

Works seamlessly with blockchain APIs and DeFi protocol interfaces to provide real-time data. Integrates with tax reporting tools for transaction categorization and supports export functionality for external portfolio management platforms. Compatible with whale watching services and notification systems for portfolio alerts.
---
name: Exploring Blockchain Data
description: |
  Analyzes blockchain transactions, addresses, smart contracts, blocks, and tokens across multiple networks. Automatically activates when users mention blockchain addresses (0x...), transaction hashes, ENS domains (.eth), or request analysis of smart contracts, DeFi protocols, NFT collections, or crypto wallets. Provides comprehensive data including balances, transaction history, contract verification, gas analysis, and security assessments.
---

## Overview

This skill enables comprehensive blockchain data analysis through natural language queries. It automatically detects blockchain-related requests and provides detailed insights into addresses, transactions, smart contracts, and tokens across Ethereum and other major networks.

## How It Works

1. **Detection**: Recognizes blockchain identifiers (addresses, transaction hashes, ENS domains) and analysis keywords
2. **Query Processing**: Translates natural language requests into structured blockchain data queries
3. **Analysis**: Retrieves and analyzes on-chain data including balances, transactions, contract details, and token information
4. **Reporting**: Presents findings in clear, actionable formats with security insights and recommendations

## When to Use This Skill

- Analyzing wallet addresses or checking balances
- Investigating suspicious transactions or failed transfers
- Researching smart contracts before interacting with them
- Auditing DeFi protocol security and functionality
- Tracking token movements and holder distributions
- Exploring NFT collections and ownership
- Monitoring block production and network activity
- Resolving ENS domains to addresses

## Examples

### Example 1: Address Analysis
User request: "Analyze this wallet: 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb"

The skill will:
1. Retrieve address balance and token holdings
2. Analyze transaction history and activity patterns
3. Identify contract interactions and DeFi usage
4. Classify address type (EOA, contract, exchange, etc.)
5. Present portfolio overview with risk assessment

### Example 2: Transaction Investigation
User request: "Why did this transaction fail? 0xabc123def456..."

The skill will:
1. Fetch transaction details and status
2. Decode function calls and input parameters
3. Analyze gas usage and fee calculations
4. Identify failure reasons from event logs
5. Provide troubleshooting recommendations

### Example 3: Smart Contract Audit
User request: "Is this USDC contract legitimate? 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"

The skill will:
1. Verify contract source code and audit status
2. Check token standard compliance (ERC-20/721/1155)
3. Analyze contract functions and permissions
4. Review security features and upgrade mechanisms
5. Compare against known legitimate contracts

### Example 4: ENS Domain Lookup
User request: "Show me vitalik.eth portfolio"

The skill will:
1. Resolve ENS domain to Ethereum address
2. Analyze wallet holdings and transaction history
3. Track NFT collections and notable transactions
4. Identify associated addresses and contracts
5. Present comprehensive portfolio analysis

## Best Practices

- **Address Verification**: Always verify contract addresses against official sources before interacting
- **Gas Analysis**: Review gas usage patterns to identify optimal transaction timing
- **Security Focus**: Pay attention to contract verification status and admin key warnings
- **Multi-Network**: Specify network when analyzing cross-chain addresses
- **Historical Context**: Consider transaction timestamps and market conditions during analysis

## Integration

Works seamlessly with development workflows by providing blockchain context during smart contract development, DeFi integration testing, and security audits. Complements code analysis tools by offering real-time on-chain data to validate contract behavior and identify potential issues before deployment.
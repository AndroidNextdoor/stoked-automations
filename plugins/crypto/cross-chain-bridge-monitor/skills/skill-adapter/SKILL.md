---
name: Monitoring Cross-Chain Bridge Security
description: |
  Monitors cross-chain bridge activity, tracks token transfers, analyzes bridge security metrics, and detects potential exploits across major bridges like Wormhole, Multichain, Stargate, and others. Activates when users ask about bridge monitoring, transfer tracking, bridge security analysis, TVL changes, transaction status, bridge fees, exploit detection, or cross-chain transfer optimization.
---

## Overview

This skill enables comprehensive monitoring of cross-chain bridges, providing real-time tracking of transfers, security analysis, and exploit detection. It covers major bridges including Wormhole, Multichain, Stargate, Synapse, Hop, Across, and canonical protocol bridges.

## How It Works

1. **Bridge Selection**: Identifies relevant bridges based on user query (specific bridge names, chains, or general monitoring requests)
2. **Data Collection**: Gathers real-time data on transfers, TVL, validator status, and security metrics
3. **Analysis & Alerts**: Processes data to detect anomalies, large transfers, or potential security issues
4. **Reporting**: Presents findings with actionable insights and recommendations

## When to Use This Skill

- Monitor specific bridge activity or overall cross-chain ecosystem
- Track individual transaction status across bridges
- Compare bridge fees and transfer times
- Analyze bridge security and TVL changes
- Detect unusual patterns or potential exploits
- Optimize routing for cross-chain transfers
- Monitor large "whale" transfers across chains
- Assess bridge safety before making transfers

## Examples

### Example 1: Bridge Activity Monitoring
User request: "Monitor Wormhole bridge activity in the last 24 hours"

The skill will:
1. Connect to Wormhole bridge data sources
2. Analyze transfer volumes, destinations, and token types
3. Identify any unusual patterns or large transactions
4. Generate summary report with key metrics and alerts

### Example 2: Transaction Status Tracking
User request: "What's the status of my bridge transaction 0x123abc...?"

The skill will:
1. Identify the bridge used based on transaction hash
2. Query bridge APIs for current status and confirmations
3. Provide estimated completion time and any issues
4. Alert if transaction appears stuck or failed

### Example 3: Bridge Security Assessment
User request: "Is Multichain safe to use right now?"

The skill will:
1. Check Multichain's current TVL and recent changes
2. Analyze validator set health and recent security events
3. Review audit status and community sentiment
4. Provide risk assessment with specific recommendations

### Example 4: Fee Comparison
User request: "Compare costs for bridging 1000 USDC from Ethereum to Arbitrum"

The skill will:
1. Query multiple bridges supporting ETH-Arbitrum route
2. Calculate total costs including gas and bridge fees
3. Estimate transfer times for each option
4. Recommend optimal bridge based on cost and speed preferences

## Best Practices

- **Security First**: Always check bridge health metrics before recommending transfers
- **Real-time Data**: Use current data as bridge conditions change rapidly
- **Risk Communication**: Clearly explain security trade-offs between different bridge types
- **Context Awareness**: Consider user's risk tolerance and transfer urgency
- **Multi-source Verification**: Cross-reference data from multiple sources for accuracy

## Integration

Works seamlessly with wallet monitoring tools for end-to-end transfer tracking, DeFi analytics for TVL verification, and security scanning tools for exploit detection. Can trigger alerts through notification systems when anomalies are detected or when monitored transactions complete.
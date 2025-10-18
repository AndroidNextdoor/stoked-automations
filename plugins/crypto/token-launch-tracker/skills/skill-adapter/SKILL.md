---
name: Tracking Token Launches and Detecting Rugpulls
description: |
  Monitors new cryptocurrency token launches across multiple blockchain networks and analyzes them for potential rugpulls, scams, and security vulnerabilities. Activates when users discuss new token analysis, rugpull detection, contract security verification, liquidity lock checking, or ask about token safety. Provides real-time launch detection, contract security analysis, liquidity monitoring, social verification, and comprehensive risk scoring for early-stage crypto projects.
---

## Overview

This skill enables Claude Code to automatically monitor new token launches, detect potential rugpulls and honeypots, and perform comprehensive security analysis of smart contracts. It provides risk assessment scores and identifies red flags to help users avoid cryptocurrency scams.

## How It Works

1. **Launch Detection**: Monitors blockchain networks (Ethereum, BSC, Polygon, Arbitrum) for new token contracts and DEX pair creations
2. **Security Analysis**: Performs static analysis on smart contracts to identify dangerous functions, mint capabilities, and ownership controls
3. **Risk Assessment**: Calculates composite risk scores based on contract security, liquidity locks, team verification, and trading metrics
4. **Alert Generation**: Provides real-time notifications for new launches, detected rugpulls, and liquidity removal events

## When to Use This Skill

- Analyzing newly launched tokens or contracts
- Checking if a token is a potential rugpull or honeypot
- Verifying contract security and ownership status
- Monitoring liquidity locks and LP token burns
- Assessing team legitimacy and social media presence
- Getting safety ratings for early-stage crypto projects
- Tracking new launches on specific blockchain networks

## Examples

### Example 1: Token Security Analysis
User request: "Is this contract address 0x1234abcd a rugpull? Check the security"

The skill will:
1. Analyze the smart contract code for dangerous functions like hidden mints or blacklist capabilities
2. Check ownership status, liquidity locks, and audit reports
3. Provide a comprehensive risk score with specific red flags identified

### Example 2: New Launch Monitoring
User request: "Show me the safest new token launches from today"

The skill will:
1. Scan recent token launches across configured networks
2. Filter by minimum risk thresholds and safety criteria
3. Present a ranked list with risk scores and key safety indicators

### Example 3: Liquidity Verification
User request: "Check if liquidity is locked for token NEWCOIN"

The skill will:
1. Locate the token's liquidity pool contracts
2. Verify LP token locks on platforms like Team Finance, Unicrypt, or PinkLock
3. Report lock duration, amount, and unlock dates

## Best Practices

- **Risk Assessment**: Always check multiple indicators - contract verification, ownership renouncement, liquidity locks, and team transparency
- **Red Flag Priority**: Treat unverified contracts, no liquidity locks, and anonymous teams as critical warning signs
- **Network Coverage**: Monitor launches across multiple networks as scammers often migrate between chains
- **Social Verification**: Cross-reference team information and social media presence for legitimacy
- **Liquidity Thresholds**: Set minimum liquidity requirements to filter out micro-cap potential scams

## Integration

Works seamlessly with blockchain explorers (Etherscan, BSCScan), DEX platforms (Uniswap, PancakeSwap), security tools (Token Sniffer, Honeypot.is), and audit databases (CertiK, PeckShield). Integrates with portfolio management tools to flag risky holdings and provides data feeds for automated trading systems with safety filters.
---
name: Calculating Cryptocurrency Taxes
description: |
  Automatically calculates cryptocurrency taxes using FIFO, LIFO, HIFO, or Specific ID accounting methods when users mention tax calculations, capital gains, crypto taxes, tax reports, Form 8949, or Schedule D. Processes transaction data to determine cost basis, calculate short-term and long-term capital gains/losses, handle DeFi activities like staking and lending rewards, and generate comprehensive tax reports with IRS form preparation. Triggers on phrases like "calculate my crypto taxes," "tax liability," "capital gains on Bitcoin," "generate tax report," or "prepare Form 8949."
---

## Overview
This skill activates the crypto-tax-calculator plugin to compute comprehensive cryptocurrency tax obligations. It processes trading history, applies selected accounting methods, calculates capital gains and losses, and generates professional tax reports including IRS forms.

## How It Works
1. **Transaction Import**: Imports cryptocurrency transactions from exchanges, wallets, or CSV files
2. **Method Selection**: Applies chosen accounting method (FIFO, LIFO, HIFO, or Specific ID) to determine cost basis
3. **Tax Calculation**: Computes short-term and long-term capital gains, handles DeFi activities, and applies wash sale rules
4. **Report Generation**: Creates detailed tax reports and prepares Form 8949 and Schedule D for filing

## When to Use This Skill
- User mentions calculating crypto taxes or tax liability
- User asks about capital gains on specific cryptocurrencies
- User needs to generate tax reports or prepare IRS forms
- User discusses FIFO, LIFO accounting methods for crypto
- User mentions Form 8949, Schedule D, or tax preparation
- User asks about DeFi tax implications (staking, lending, yield farming)
- User needs to handle airdrop or mining income taxation

## Examples

### Example 1: Basic Tax Calculation
User request: "I need to calculate my Bitcoin taxes for 2023 using FIFO method"

The skill will:
1. Import Bitcoin transaction history from specified sources
2. Apply FIFO accounting to determine cost basis for each sale
3. Calculate capital gains/losses and categorize as short-term or long-term
4. Generate comprehensive tax report with totals and transaction details

### Example 2: DeFi Tax Reporting  
User request: "Help me prepare Form 8949 for my Ethereum staking rewards and trades"

The skill will:
1. Process both trading transactions and staking reward events
2. Calculate ordinary income from staking at fair market value
3. Determine capital gains on subsequent sales of staked ETH
4. Generate Form 8949 with proper categorization and Schedule D summary

### Example 3: Multi-Currency Portfolio
User request: "Generate a complete crypto tax report for all my altcoin trades"

The skill will:
1. Import transactions across multiple cryptocurrencies and exchanges
2. Apply consistent accounting method to entire portfolio
3. Handle crypto-to-crypto trades with proper USD conversions
4. Create consolidated report showing total gains/losses by holding period

## Best Practices
- **Data Accuracy**: Verify all transaction imports are complete and accurate before calculation
- **Method Consistency**: Use the same accounting method across all cryptocurrencies for the tax year
- **Record Keeping**: Maintain detailed transaction records and backup reports for audit purposes
- **Professional Review**: Consider professional tax advisor review for complex DeFi activities

## Integration
Works seamlessly with portfolio tracking tools and tax preparation software. Exports can be imported directly into TurboTax, TaxAct, and other tax preparation platforms. Integrates with popular exchanges for automated transaction import.
---
name: Analyzing Financial Markets with OpenBB
description: |
  Automatically activates OpenBB Terminal integration when users request financial analysis, investment research, stock analysis, crypto tracking, portfolio optimization, or market data. Provides comprehensive equity analysis, cryptocurrency insights, macroeconomic indicators, options analysis, and AI-powered investment research using OpenBB Platform's open-source financial data infrastructure.
---

## Overview

This skill transforms Claude Code into a professional investment research terminal using OpenBB Platform. It automatically detects financial analysis requests and provides institutional-grade market data, fundamental analysis, technical indicators, and AI-powered insights across equities, crypto, macro economics, and portfolio management.

## How It Works

1. **Detection**: Recognizes financial analysis requests through trigger phrases like "analyze stock", "crypto analysis", "portfolio performance", "market data", or "investment research"
2. **Data Retrieval**: Connects to OpenBB Platform to fetch real-time and historical financial data from multiple sources
3. **Analysis & Insights**: Processes data through financial models and generates AI-powered investment insights and recommendations

## When to Use This Skill

- User mentions stock tickers (AAPL, TSLA, SPY) or asks for equity analysis
- Requests for cryptocurrency analysis, on-chain metrics, or DeFi data
- Portfolio performance reviews, optimization, or rebalancing discussions
- Macroeconomic analysis, GDP data, inflation trends, or central bank policy
- Options analysis, Greeks calculation, or derivatives strategies
- Investment thesis generation or market research requests
- Financial modeling, valuation analysis, or screening requirements

## Examples

### Example 1: Equity Analysis
User request: "Can you analyze Apple's stock performance and fundamentals?"

The skill will:
1. Execute `/openbb-equity AAPL --analysis=all` to gather comprehensive data
2. Present price history, financial ratios, analyst ratings, and technical indicators
3. Generate AI-powered investment thesis with risk assessment and price targets

### Example 2: Crypto Market Analysis
User request: "What's happening with Bitcoin and the overall crypto market?"

The skill will:
1. Run `/openbb-crypto BTC` to fetch price data, on-chain metrics, and market sentiment
2. Analyze whale activity, network health, and social indicators
3. Provide market outlook with support/resistance levels and trend analysis

### Example 3: Portfolio Optimization
User request: "Help me analyze my portfolio performance and suggest improvements"

The skill will:
1. Execute `/openbb-portfolio --analyze` to calculate performance metrics and risk measures
2. Generate asset allocation recommendations and rebalancing suggestions
3. Identify correlation risks and propose diversification strategies

### Example 4: Macroeconomic Research
User request: "What do current economic indicators suggest about market direction?"

The skill will:
1. Run `/openbb-macro --indicators=all` to gather GDP, inflation, employment, and rate data
2. Analyze trends and their historical impact on different asset classes
3. Provide macro-driven investment recommendations and sector rotation strategies

## Best Practices

- **Data Verification**: Always cross-reference critical data points from multiple OpenBB sources before making investment recommendations
- **Risk Disclosure**: Include appropriate risk warnings and disclaimers with all investment analysis and recommendations
- **Context Awareness**: Consider current market conditions, volatility regimes, and economic cycles when interpreting data
- **Multi-Timeframe Analysis**: Combine short-term technical signals with long-term fundamental trends for comprehensive insights
- **Quantitative Focus**: Leverage OpenBB's quantitative capabilities for backtesting, statistical analysis, and model validation

## Integration

Works seamlessly with Claude Code's development environment to provide financial data alongside coding capabilities. Integrates with portfolio management workflows, automated trading strategies, and financial modeling projects. Can export analysis results to various formats (CSV, JSON, charts) for use in presentations, reports, or further analysis. Compatible with Jupyter notebooks, Python scripts, and other financial analysis tools in the development stack.
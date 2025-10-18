---
name: Backtesting Trading Strategies
description: |
  Performs comprehensive backtesting of trading strategies using historical market data. Activates when users mention "backtest strategy", "test trading approach", "historical performance", "strategy analysis", or "trading simulation". Provides detailed performance metrics including returns, Sharpe ratios, drawdowns, and risk analysis. Supports multiple strategy types like moving averages, RSI, MACD, breakout, and mean reversion strategies with parameter optimization capabilities.
---

## Overview
This skill automatically activates the trading-strategy-backtester plugin to test trading strategies against historical market data. It provides comprehensive performance analysis, risk metrics, and optimization tools to evaluate strategy effectiveness before live trading.

## How It Works
1. **Strategy Selection**: Choose from pre-built strategies (MA crossover, RSI, MACD, breakout) or define custom logic
2. **Data Analysis**: Process historical price data with specified timeframes and market conditions
3. **Performance Calculation**: Generate detailed metrics including returns, ratios, drawdowns, and risk measures
4. **Optimization**: Fine-tune parameters and compare strategy variations for optimal performance

## When to Use This Skill
- Testing trading strategies before live implementation
- Analyzing historical performance of investment approaches
- Optimizing strategy parameters for better returns
- Comparing multiple trading strategies side-by-side
- Evaluating risk-adjusted returns and drawdown characteristics
- Conducting walk-forward analysis for strategy robustness

## Examples

### Example 1: Moving Average Strategy Test
User request: "I want to backtest a moving average crossover strategy on Bitcoin"

The skill will:
1. Configure MA crossover parameters (50/200 day defaults)
2. Load BTC historical data and simulate trades
3. Calculate total return, win rate, Sharpe ratio, and maximum drawdown
4. Present comprehensive performance report with trade analysis

### Example 2: RSI Strategy Optimization
User request: "Help me optimize RSI parameters for my overbought/oversold strategy"

The skill will:
1. Set up RSI strategy with customizable thresholds
2. Run parameter sweeps across different RSI levels and periods
3. Analyze performance across various market conditions
4. Recommend optimal parameters based on risk-adjusted returns

### Example 3: Strategy Comparison Analysis
User request: "Compare MACD vs breakout strategies for EUR/USD trading"

The skill will:
1. Execute both strategies on EUR/USD historical data
2. Generate side-by-side performance comparisons
3. Calculate relative risk metrics and return profiles
4. Provide recommendation based on trading objectives

## Best Practices
- **Data Quality**: Ensure sufficient historical data for reliable backtesting results
- **Parameter Sensitivity**: Test multiple parameter sets to avoid overfitting
- **Risk Management**: Always include stop-loss and position sizing in strategy tests
- **Market Conditions**: Backtest across different market cycles (bull, bear, sideways)
- **Transaction Costs**: Include realistic fees and slippage in backtesting calculations

## Integration
Works seamlessly with market data providers and portfolio management tools. Results can be exported for further analysis in spreadsheet applications or integrated with live trading platforms for strategy deployment. Compatible with risk management systems for position sizing and portfolio optimization.
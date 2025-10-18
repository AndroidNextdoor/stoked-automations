---
name: Planning Travel Itineraries
description: |
  Activates when users request travel planning, itineraries, trip advice, or destination information. This skill uses the travel-assistant plugin to provide comprehensive travel planning including real-time weather forecasts, currency conversion, AI-powered itinerary generation, packing lists, and local expert tips. Triggers on phrases like "plan a trip," "travel to," "visit," "itinerary for," "weather in," "currency conversion," "what to pack," or destination-specific questions.
---

## Overview
This skill transforms travel planning from hours of research into AI-powered assistance. It provides complete travel intelligence including weather forecasts, currency rates, personalized itineraries, packing recommendations, and cultural insights for any destination worldwide.

## How It Works
1. **Trip Analysis**: Processes destination, duration, budget, and interests to create comprehensive travel plans
2. **Real-time Data**: Fetches current weather, exchange rates, and timezone information for accurate planning
3. **AI Optimization**: Generates personalized itineraries with geographic clustering and weather-based scheduling
4. **Cultural Intelligence**: Provides local expert tips, customs, hidden gems, and safety information
5. **Practical Preparation**: Creates optimized packing lists and budget breakdowns

## When to Use This Skill
- Planning trips or vacations to any destination
- Checking weather conditions for travel dates
- Converting currencies or planning travel budgets
- Creating day-by-day itineraries for cities or countries
- Getting packing recommendations for different climates
- Learning about local customs and cultural insights
- Comparing multiple destinations for travel decisions
- Coordinating meetings across different time zones

## Examples

### Example 1: Complete Trip Planning
User request: "I want to plan a 7-day trip to Tokyo with a budget of $3000"

The skill will:
1. Generate comprehensive travel plan using `/travel "Tokyo, Japan" --days 7 --budget 3000`
2. Provide 7-day weather forecast with packing recommendations
3. Create detailed budget breakdown with currency conversion to JPY
4. Generate day-by-day itinerary with top attractions and local experiences
5. Include cultural tips, safety information, and transportation guide

### Example 2: Weather and Packing Assistance
User request: "What's the weather like in Iceland next week and what should I pack?"

The skill will:
1. Check detailed weather forecast using `/weather Iceland --days 7`
2. Generate weather-optimized packing list using `/pack "Iceland" --days 7`
3. Recommend best days for outdoor activities like Northern Lights viewing
4. Provide clothing recommendations for variable weather conditions

### Example 3: Multi-City Itinerary
User request: "Help me plan a route through Rome, Florence, and Venice over 10 days"

The skill will:
1. Create multi-city plan using `/travel "Rome → Florence → Venice" --days 10`
2. Optimize travel timing between cities based on weather and logistics
3. Generate city-specific itineraries with must-see attractions and hidden gems
4. Provide transportation recommendations between destinations

### Example 4: Currency and Budget Planning
User request: "How much is $2000 in euros and help me budget for Paris"

The skill will:
1. Convert currency using `/currency 2000 USD EUR --budget`
2. Show real-time exchange rates with 30-day trends
3. Break down daily spending recommendations for Paris
4. Provide tips for best currency exchange methods and avoiding fees

## Best Practices
- **Comprehensive Planning**: Use the complete `/travel` command for new trips to get all essential information at once
- **Specific Interests**: Include user interests and pace preferences for personalized itinerary recommendations
- **Multi-destination Optimization**: For complex trips, use multi-city syntax to optimize routing and timing
- **Weather Integration**: Always check weather forecasts when planning activities and packing recommendations
- **Cultural Sensitivity**: Incorporate local customs and cultural insights to enhance travel experiences
- **Budget Optimization**: Use currency conversion with budget breakdowns to plan realistic spending

## Integration
Works seamlessly with calendar applications for itinerary scheduling, weather services for real-time forecasting, financial tools for currency tracking, and mapping services for geographic optimization. Integrates with local expert knowledge bases and cultural guides to provide authentic travel experiences beyond typical tourist recommendations.
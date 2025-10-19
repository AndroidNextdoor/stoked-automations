# Firecrawl MCP Server

Advanced web scraping and crawling via MCP (Model Context Protocol) - extract structured data, convert pages to markdown, generate sitemaps, and automate web data collection with AI assistance.

## Overview

Firecrawl MCP server provides powerful web scraping capabilities directly within Claude Code, enabling you to:

- **Single Page Scraping**: Convert any webpage to clean markdown
- **Website Crawling**: Recursively crawl entire websites following links
- **Sitemap Generation**: Map website structure and discover all pages
- **Structured Data Extraction**: AI-powered extraction of structured data
- **Batch Processing**: Scrape multiple URLs in parallel
- **Web Search**: Search and scrape top results automatically

## Features

- **Clean Markdown Output** - Convert HTML to readable markdown
- **JavaScript Rendering** - Handle dynamic content and SPAs
- **Smart Link Following** - Intelligent crawling with depth control
- **Schema Detection** - Automatic structured data extraction
- **Rate Limiting** - Built-in throttling for respectful scraping
- **Proxy Support** - Rotate IPs for large-scale scraping
- **Custom Selectors** - Target specific page elements
- **Screenshot Capture** - Visual page snapshots (premium)

## Prerequisites

Before using this plugin, you need:

1. **Firecrawl API Key**
   ```bash
   # Sign up at https://firecrawl.dev
   # Get your API key from dashboard
   export FIRECRAWL_API_KEY="fc-your-api-key-here"
   ```

2. **Node.js** (for npx execution)
   ```bash
   node --version  # Should be v18+
   ```

3. **Optional: Self-Hosted Instance**
   ```bash
   # If using self-hosted Firecrawl
   export FIRECRAWL_API_URL="https://your-firecrawl-instance.com"
   ```

## Installation

### Step 1: Add Stoked Automations Marketplace

```bash
/plugin marketplace add AndroidNextdoor/stoked-automations
```

### Step 2: Install Plugin

```bash
/plugin install firecrawl-mcp@stoked-automations
```

### Step 3: Configure Environment

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
# Firecrawl Configuration
export FIRECRAWL_API_KEY="fc-your-api-key-here"

# Optional: Self-hosted instance
# export FIRECRAWL_API_URL="https://your-instance.com"
```

Reload your shell:
```bash
source ~/.zshrc  # or ~/.bashrc
```

### Step 4: Restart Claude Code

Completely exit and restart Claude Code for the MCP server to activate.

### Step 5: Verify Installation

```bash
# Check that MCP tools are available
/mcp list | grep firecrawl

# You should see:
# - mcp__firecrawl__scrape_url
# - mcp__firecrawl__crawl_website
# - mcp__firecrawl__map_website
# - mcp__firecrawl__extract_structured_data
# - mcp__firecrawl__batch_scrape
# - mcp__firecrawl__search_web
```

## Usage

### Scrape a Single Page

```
Scrape the content from https://example.com and convert it to markdown
```

Returns:
- Clean markdown content
- Extracted metadata (title, description, author)
- Links found on the page
- Images and media

### Crawl an Entire Website

```
Crawl https://docs.example.com and extract all documentation pages
```

Returns:
- All discovered pages as markdown
- Site structure and hierarchy
- Internal link graph
- Content from each page

### Generate Website Sitemap

```
Map the structure of https://example.com
```

Returns:
- Complete sitemap
- Page hierarchy
- URL list
- Link relationships

### Extract Structured Data

```
Extract product information from https://shop.example.com/product/123
```

Returns:
- Structured data based on page content
- JSON schema detection
- Named entities
- Key-value pairs

### Batch Scrape Multiple URLs

```
Scrape these URLs in parallel:
- https://example.com/page1
- https://example.com/page2
- https://example.com/page3
```

Returns:
- Markdown for each URL
- Metadata for each page
- Error handling for failed pages

### Web Search and Scrape

```
Search for "Claude Code plugins" and scrape the top 5 results
```

Returns:
- Search results with rankings
- Scraped content from each result
- Clean markdown for analysis

## Available MCP Tools

| Tool | Description | Use Case |
|------|-------------|----------|
| `scrape_url` | Scrape single webpage | Documentation extraction, article reading |
| `crawl_website` | Recursive website crawling | Complete site backup, content migration |
| `map_website` | Generate sitemap | SEO analysis, site architecture review |
| `extract_structured_data` | AI-powered data extraction | Product catalogs, contact lists |
| `batch_scrape` | Parallel URL scraping | Bulk data collection, comparison |
| `search_web` | Search and scrape results | Research, competitive analysis |

## Configuration

The MCP server is configured via `~/.config/claude/config.json` (automatically managed by the plugin):

```json
{
  "mcpServers": {
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "@mendable/firecrawl-mcp"],
      "env": {
        "FIRECRAWL_API_KEY": "${FIRECRAWL_API_KEY}",
        "FIRECRAWL_API_URL": "${FIRECRAWL_API_URL:-https://api.firecrawl.dev}"
      }
    }
  }
}
```

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `FIRECRAWL_API_KEY` | Yes | - | Your Firecrawl API key |
| `FIRECRAWL_API_URL` | No | https://api.firecrawl.dev | API endpoint URL |

## Examples

### Example 1: Documentation Extraction

```
User: "Extract all documentation from https://docs.stripe.com/api"

Claude will:
1. Use mcp__firecrawl__crawl_website to recursively crawl
2. Extract clean markdown from each page
3. Organize content by section
4. Generate table of contents
5. Provide structured documentation
```

### Example 2: Competitive Analysis

```
User: "Scrape pricing pages from these competitors:
- https://competitor1.com/pricing
- https://competitor2.com/pricing
- https://competitor3.com/pricing"

Claude will:
1. Use mcp__firecrawl__batch_scrape for parallel scraping
2. Extract pricing tiers and features
3. Structure data for comparison
4. Generate comparison table
```

### Example 3: Content Migration

```
User: "I need to migrate content from my old WordPress site to a new CMS.
Crawl https://old-site.com and extract all blog posts."

Claude will:
1. Use mcp__firecrawl__map_website to discover all URLs
2. Use mcp__firecrawl__crawl_website to extract content
3. Convert HTML to clean markdown
4. Extract metadata (author, date, categories)
5. Organize posts for migration
```

### Example 4: Research Automation

```
User: "Research the latest developments in quantum computing.
Search for recent articles and extract key findings."

Claude will:
1. Use mcp__firecrawl__search_web with query "quantum computing 2025"
2. Scrape top 10 results
3. Extract key points from each article
4. Summarize findings
5. Provide citations
```

### Example 5: Product Catalog Extraction

```
User: "Extract all products from https://shop.example.com/catalog"

Claude will:
1. Use mcp__firecrawl__crawl_website to find all product pages
2. Use mcp__firecrawl__extract_structured_data for each product
3. Extract: name, price, description, images, SKU
4. Generate structured JSON or CSV
5. Validate data completeness
```

## Common Workflows

### Workflow 1: Website Archival

```
1. Map website structure
   → mcp__firecrawl__map_website
   → Generate complete sitemap

2. Crawl all pages
   → mcp__firecrawl__crawl_website
   → Extract markdown for each page

3. Store in knowledge base
   → Use serena MCP to persist content
   → Create searchable archive
```

### Workflow 2: SEO Analysis

```
1. Generate sitemap
   → mcp__firecrawl__map_website
   → Analyze URL structure

2. Extract metadata
   → mcp__firecrawl__scrape_url for each page
   → Collect titles, descriptions, headers

3. Analyze content
   → Check keyword density
   → Identify optimization opportunities
   → Generate SEO report
```

### Workflow 3: Data Collection Pipeline

```
1. Discover target URLs
   → mcp__firecrawl__map_website
   → Filter by URL patterns

2. Batch scrape
   → mcp__firecrawl__batch_scrape
   → Parallel processing for speed

3. Extract structured data
   → mcp__firecrawl__extract_structured_data
   → Convert to database schema

4. Store and analyze
   → Export to CSV/JSON
   → Import to database
   → Visualize insights
```

## Advanced Features

### Custom Scraping Rules

```javascript
// Example: Scrape with custom selectors
{
  "url": "https://example.com",
  "includeSelectors": [".article-content"],
  "excludeSelectors": [".ads", ".sidebar"],
  "waitFor": 3000  // Wait for JS to load
}
```

### Rate Limiting

```javascript
// Example: Respectful crawling
{
  "url": "https://example.com",
  "maxPages": 100,
  "crawlDelay": 1000,  // 1 second between requests
  "maxDepth": 3
}
```

### Schema-Based Extraction

```javascript
// Example: Extract with schema
{
  "url": "https://shop.example.com/product",
  "schema": {
    "name": "string",
    "price": "number",
    "description": "string",
    "inStock": "boolean"
  }
}
```

## Troubleshooting

### "API key not found" Error

```bash
# Verify environment variable is set
echo $FIRECRAWL_API_KEY

# If empty, add to shell profile
export FIRECRAWL_API_KEY="fc-your-key"
source ~/.zshrc
```

### "Command not found: npx" Error

```bash
# Install Node.js
brew install node  # macOS
# or
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install node
```

### MCP Tools Not Appearing

- Restart Claude Code completely (not just reload)
- Check config.json syntax: `jq . ~/.config/claude/config.json`
- Verify npx is in PATH: `which npx`

### Slow Scraping Performance

- Use `batch_scrape` for multiple URLs
- Increase `crawlDelay` if getting rate limited
- Consider upgrading Firecrawl plan for higher limits

### JavaScript-Heavy Sites Not Rendering

- Firecrawl handles JS by default
- For complex SPAs, increase `waitFor` timeout
- Check Firecrawl dashboard for rendering logs

## Best Practices

1. **Respect robots.txt** - Check site's crawling rules
2. **Rate Limiting** - Use appropriate delays between requests
3. **Error Handling** - Handle failed pages gracefully
4. **Data Validation** - Verify extracted data quality
5. **Legal Compliance** - Ensure scraping is permitted
6. **API Limits** - Monitor usage against plan limits
7. **Caching** - Store scraped data to avoid re-scraping

## Use Cases

### Content Creation
- Research competitor content
- Aggregate news articles
- Extract quotes and citations
- Collect reference materials

### Data Analysis
- Price monitoring
- Product comparison
- Market research
- Trend analysis

### SEO & Marketing
- Competitor analysis
- Backlink research
- Content gap analysis
- Keyword research

### Development
- API documentation extraction
- Code example collection
- Migration assistance
- Quality assurance

## Pricing

Firecrawl offers multiple tiers:

- **Free Tier**: 500 pages/month
- **Starter**: $49/month - 10,000 pages
- **Pro**: $199/month - 100,000 pages
- **Enterprise**: Custom pricing

Check https://firecrawl.dev/pricing for current plans.

## Related Plugins

- **serena**: Store scraped content in persistent memory
- **atlassian-mcp**: Track scraping tasks in Jira
- **gitlab-mcp**: Version control scraped data
- **context7**: Combine with code context for analysis

## Resources

- **Firecrawl Documentation**: https://docs.firecrawl.dev/
- **MCP Server Guide**: https://docs.firecrawl.dev/mcp-server
- **API Reference**: https://docs.firecrawl.dev/api-reference
- **GitHub Repository**: https://github.com/mendableai/firecrawl

## License

MIT License - see [LICENSE](./LICENSE) for details

## Author

**Mendable.ai**
- GitHub: https://github.com/mendableai
- Website: https://firecrawl.dev

---

**Plugin Version**: 1.0.0
**Category**: Productivity
**Last Updated**: 2025-10-18

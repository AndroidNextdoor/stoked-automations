---
name: Web Scraping and Data Extraction
description: |
  Activates when users need to scrape websites, extract web data, convert pages to markdown, crawl entire sites, or collect structured data from the web. Triggers on phrases like "scrape website", "extract data from URL", "crawl this site", "convert webpage to markdown", "get website content", "map site structure", "batch scrape URLs", or "search and scrape web". Uses Firecrawl MCP server for professional-grade web data extraction with JavaScript rendering, clean markdown conversion, and AI-powered structured data extraction.
---

## Overview

This skill enables Claude to perform advanced web scraping and data extraction using the **Firecrawl MCP server**. It provides professional-grade web scraping capabilities including JavaScript rendering, recursive website crawling, clean markdown conversion, and AI-powered structured data extraction.

## How It Works

1. **Target Identification**: Analyzes user request to identify URLs and scraping requirements
2. **Tool Selection**: Chooses appropriate Firecrawl MCP tool (scrape, crawl, map, extract)
3. **Data Collection**: Executes scraping with JavaScript rendering and clean HTML processing
4. **Content Processing**: Converts HTML to markdown, extracts structured data
5. **Result Delivery**: Provides clean, formatted content ready for analysis

## When to Use This Skill

This skill activates when you need to:
- Scrape content from single webpages
- Crawl entire websites recursively
- Generate website sitemaps
- Extract structured data from web pages
- Convert HTML to clean markdown
- Batch process multiple URLs
- Search web and scrape results
- Collect data for analysis or migration

## MCP Tools Available

### Core Scraping Tools

| Tool | Function | Best For |
|------|----------|----------|
| `scrape_url` | Single page scraping | Articles, documentation, individual pages |
| `crawl_website` | Recursive crawling | Complete sites, documentation sets |
| `map_website` | Sitemap generation | Site structure, URL discovery |
| `extract_structured_data` | AI-powered extraction | Products, contacts, structured content |
| `batch_scrape` | Parallel URL processing | Multiple pages, comparison data |
| `search_web` | Search and scrape | Research, competitive analysis |

## Examples

### Example 1: Documentation Extraction

User request: "Scrape all the API documentation from https://docs.stripe.com/api"

The skill will:
1. **Site Mapping** - Use `mcp__firecrawl__map_website` to discover all documentation pages
2. **Recursive Crawling** - Use `mcp__firecrawl__crawl_website` to extract content
3. **Markdown Conversion** - Convert each page to clean, readable markdown
4. **Content Organization** - Structure documentation by sections and hierarchy
5. **Table of Contents** - Generate navigation and reference structure
6. **Deliverable** - Complete API reference in markdown format

**Firecrawl MCP Tools Used:**
- `map_website`: Discover all documentation URLs
- `crawl_website`: Extract content from all pages
- Clean markdown output for each page

### Example 2: Competitive Pricing Analysis

User request: "Compare pricing from these SaaS competitors:
- https://competitor1.com/pricing
- https://competitor2.com/pricing
- https://competitor3.com/pricing"

The skill will:
1. **Parallel Scraping** - Use `mcp__firecrawl__batch_scrape` for all URLs simultaneously
2. **Data Extraction** - Use `mcp__firecrawl__extract_structured_data` for pricing tiers
3. **Feature Comparison** - Extract features for each pricing plan
4. **Data Structuring** - Organize pricing into comparable format
5. **Analysis** - Generate comparison table with key differentiators

**Firecrawl MCP Tools Used:**
- `batch_scrape`: Parallel processing for speed
- `extract_structured_data`: Extract pricing, features, limits
- Output: Structured comparison table

### Example 3: Content Migration

User request: "I need to migrate all blog posts from my old WordPress site at https://old-blog.com to a new CMS"

The skill will:
1. **URL Discovery** - Use `mcp__firecrawl__map_website` to find all blog post URLs
2. **Content Extraction** - Use `mcp__firecrawl__crawl_website` to get all posts
3. **Metadata Extraction** - Extract titles, authors, dates, categories, tags
4. **Media Collection** - Identify and catalog all images/videos
5. **Format Conversion** - Convert to clean markdown with frontmatter
6. **Export** - Generate migration-ready files

**Firecrawl MCP Tools Used:**
- `map_website`: Discover all blog post URLs
- `crawl_website`: Extract complete content
- `extract_structured_data`: Parse metadata
- Output: Migration-ready markdown files with metadata

### Example 4: Research Automation

User request: "Research the latest AI developments. Search for recent articles and summarize key findings."

The skill will:
1. **Web Search** - Use `mcp__firecrawl__search_web` with query "AI developments 2025"
2. **Result Scraping** - Automatically scrape top 10 search results
3. **Content Extraction** - Get clean article content in markdown
4. **Key Point Extraction** - Identify main findings from each article
5. **Synthesis** - Generate comprehensive summary
6. **Citations** - Provide proper source attribution

**Firecrawl MCP Tools Used:**
- `search_web`: Search and scrape top results
- Clean markdown conversion
- Metadata extraction for citations

### Example 5: E-commerce Product Catalog

User request: "Extract all products from https://shop.stokedautomations.com/catalog including names, prices, and descriptions"

The skill will:
1. **Catalog Discovery** - Use `mcp__firecrawl__map_website` to find all product pages
2. **Product Scraping** - Use `mcp__firecrawl__crawl_website` to visit each product
3. **Data Extraction** - Use `mcp__firecrawl__extract_structured_data` with product schema
4. **Field Mapping** - Extract: name, price, description, SKU, images, availability
5. **Data Validation** - Check completeness and data quality
6. **Export** - Generate CSV/JSON for database import

**Firecrawl MCP Tools Used:**
- `map_website`: Discover product URLs
- `crawl_website`: Visit all products
- `extract_structured_data`: Schema-based extraction
- Output: Structured product database

### Example 6: Website Archival

User request: "Create a complete backup of https://company-docs.com before we redesign the site"

The skill will:
1. **Complete Site Map** - Use `mcp__firecrawl__map_website` for full URL list
2. **Recursive Crawl** - Use `mcp__firecrawl__crawl_website` with max depth
3. **Asset Collection** - Capture all pages, images, documents
4. **Markdown Conversion** - Convert all HTML to portable markdown
5. **Structure Preservation** - Maintain site hierarchy and navigation
6. **Storage** - Use `serena` MCP to create searchable archive

**Firecrawl MCP Tools Used:**
- `map_website`: Complete sitemap generation
- `crawl_website`: Full site scraping
- Output: Complete site archive in markdown

## Workflow Integration

### Scraping Workflow Patterns

**Pattern 1: Single Page Research**
```
1. User provides URL
   └─ mcp__firecrawl__scrape_url

2. Clean markdown conversion
   └─ Extract main content
   └─ Remove ads, navigation, footers

3. Metadata extraction
   └─ Title, author, date
   └─ Social media info

4. Delivery
   └─ Clean markdown ready for analysis
```

**Pattern 2: Complete Site Crawl**
```
1. Site mapping
   └─ mcp__firecrawl__map_website
   └─ Generate URL list

2. Crawl configuration
   └─ Set max depth
   └─ Define URL patterns
   └─ Configure rate limiting

3. Recursive crawling
   └─ mcp__firecrawl__crawl_website
   └─ Follow internal links
   └─ Respect robots.txt

4. Content processing
   └─ Markdown conversion
   └─ Structure organization
   └─ Metadata extraction

5. Storage
   └─ Use serena for persistence
   └─ Create searchable index
```

**Pattern 3: Structured Data Collection**
```
1. Target identification
   └─ Identify pages with structured data
   └─ Define extraction schema

2. Crawling
   └─ mcp__firecrawl__crawl_website
   └─ Filter target URLs

3. Data extraction
   └─ mcp__firecrawl__extract_structured_data
   └─ Apply schema
   └─ Validate fields

4. Export
   └─ Generate CSV/JSON
   └─ Ready for database import
```

## Advanced Capabilities

### JavaScript Rendering

Firecrawl handles JavaScript-heavy sites automatically:
- Single Page Applications (SPAs)
- Dynamic content loading
- React, Vue, Angular apps
- Lazy-loaded images
- AJAX-based content

### Clean Markdown Conversion

Intelligent HTML to markdown:
- Remove navigation, ads, footers
- Preserve content structure
- Clean formatting
- Extract main content only
- Maintain links and images

### Schema-Based Extraction

AI-powered structured data extraction:
```json
{
  "schema": {
    "name": "string",
    "price": "number",
    "description": "string",
    "inStock": "boolean",
    "images": "array"
  }
}
```

Automatically extracts matching data from any page.

## Best Practices

- **Respect robots.txt**: Always check site's crawling permissions
- **Rate Limiting**: Use appropriate delays between requests (default: 1 second)
- **Targeted Scraping**: Use selectors to extract only needed content
- **Error Handling**: Handle failed pages gracefully
- **Data Validation**: Verify extracted data completeness
- **Legal Compliance**: Ensure scraping is permitted
- **API Limits**: Monitor usage against Firecrawl plan limits
- **Caching**: Store results to avoid redundant scraping

## Integration with Other Plugins

- **serena**: Store scraped content in persistent knowledge base
- **atlassian-mcp**: Track scraping projects and data collection tasks in Jira
- **gitlab-mcp**: Version control scraped data and migration scripts
- **context7**: Combine scraped content with code context for analysis

### Example: Research to Report Workflow

```
1. Research phase
   └─ Use mcp__firecrawl__search_web for initial research
   └─ Scrape top results automatically

2. Deep dive
   └─ Use mcp__firecrawl__crawl_website for detailed sites
   └─ Extract comprehensive information

3. Knowledge storage
   └─ Use serena to persist research findings
   └─ Create searchable knowledge base

4. Report generation
   └─ Synthesize findings
   └─ Generate citations
   └─ Create comprehensive report

5. Project tracking
   └─ Use atlassian-mcp to track research progress
   └─ Document findings in Jira
```

## Use Cases

### Content & Research
- Competitive content analysis
- Market research automation
- News aggregation
- Citation and reference collection
- Trend analysis

### E-commerce
- Price monitoring
- Product comparison
- Inventory tracking
- Review aggregation
- Competitor analysis

### SEO & Marketing
- Backlink research
- Content gap analysis
- Keyword research
- Competitor tracking
- Site auditing

### Development & Migration
- Documentation extraction
- Content migration
- API exploration
- Code example collection
- Quality assurance

## Troubleshooting

**Issue: "API key not configured"**
- Set FIRECRAWL_API_KEY environment variable
- Restart Claude Code after setting variable

**Issue: "JavaScript not rendering"**
- Firecrawl handles JS automatically
- For complex SPAs, results may take longer
- Check Firecrawl dashboard for rendering logs

**Issue: "Rate limiting errors"**
- Reduce crawl speed with longer delays
- Check Firecrawl plan limits
- Consider upgrading plan for higher limits

**Issue: "Incomplete data extraction"**
- Refine schema definition
- Check if site blocks scrapers
- Try different selectors

## Legal and Ethical Considerations

**IMPORTANT**: Web scraping must comply with legal and ethical standards.

### Legal Requirements
- Respect website Terms of Service
- Honor robots.txt directives
- Comply with GDPR and data protection laws
- Avoid scraping copyrighted content without permission

### Ethical Guidelines
- Use reasonable rate limits
- Don't overwhelm small sites with requests
- Attribute sources properly
- Respect paywalls and authentication
- Don't scrape personal information

**Unauthorized scraping may violate laws or terms of service.**

## Resources

- **Firecrawl Documentation**: https://docs.firecrawl.dev/
- **MCP Server Guide**: https://docs.firecrawl.dev/mcp-server
- **API Reference**: https://docs.firecrawl.dev/api-reference
- **Best Practices**: https://docs.firecrawl.dev/best-practices

---

**Skill Version**: 1.0.0
**MCP Server**: firecrawl
**Last Updated**: 2025-10-18

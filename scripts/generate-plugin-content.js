#!/usr/bin/env node
/**
 * Generate plugin JSON files for Astro content collection
 * from marketplace.extended.json
 */

const fs = require('fs');
const path = require('path');

const MARKETPLACE_FILE = path.join(__dirname, '../.claude-plugin/marketplace.extended.json');
const OUTPUT_DIR = path.join(__dirname, '../marketplace/src/content/plugins');

// Read marketplace data
const marketplace = JSON.parse(fs.readFileSync(MARKETPLACE_FILE, 'utf8'));

console.log(`Generating plugin JSON files from ${marketplace.plugins.length} plugins...`);

let created = 0;
let updated = 0;
let skipped = 0;

marketplace.plugins.forEach(plugin => {
  const outputFile = path.join(OUTPUT_DIR, `${plugin.name}.json`);

  // Transform marketplace plugin to Astro content format
  const contentPlugin = {
    name: plugin.name,
    displayName: plugin.name.split('-').map(word =>
      word.charAt(0).toUpperCase() + word.slice(1)
    ).join(' '),
    category: plugin.category,
    type: plugin.mcpTools ? 'mcp' : 'standard',
    description: plugin.description,
    version: plugin.version,
    author: plugin.author,
    repository: plugin.repository || `https://github.com/AndroidNextdoor/stoked-automations/tree/main/${plugin.source}`,
    license: plugin.license || 'MIT',
    keywords: plugin.keywords || [],
    features: [],
    tools: plugin.mcpTools ? Array(plugin.mcpTools).fill(null).map((_, i) => ({
      name: `tool_${i + 1}`,
      description: `MCP tool ${i + 1}`
    })) : undefined,
    installation: `/plugin install ${plugin.name}@stoked-automations`,
    usage: plugin.mcpTools ? {
      mcp: `Use MCP tools in Claude Code`
    } : {},
    examples: [],
    screenshots: [],
    documentation: `https://github.com/AndroidNextdoor/stoked-automations/blob/main/${plugin.source}/README.md`,
    tags: plugin.keywords || [],
    featured: plugin.featured || false,
    verified: true,
    downloads: 0,
    rating: 0,
    reviews: [],
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };

  // Check if file exists
  if (fs.existsSync(outputFile)) {
    // Read existing file to preserve custom data
    const existing = JSON.parse(fs.readFileSync(outputFile, 'utf8'));

    // Merge: keep existing features, examples, screenshots if they exist
    if (existing.features && existing.features.length > 0) {
      contentPlugin.features = existing.features;
    }
    if (existing.examples && existing.examples.length > 0) {
      contentPlugin.examples = existing.examples;
    }
    if (existing.screenshots && existing.screenshots.length > 0) {
      contentPlugin.screenshots = existing.screenshots;
    }
    if (existing.tools && existing.tools.length > 0) {
      contentPlugin.tools = existing.tools;
    }

    updated++;
  } else {
    created++;
  }

  // Write file
  fs.writeFileSync(outputFile, JSON.stringify(contentPlugin, null, 2));
});

console.log(`\n✅ Complete!`);
console.log(`   Created: ${created} new files`);
console.log(`   Updated: ${updated} existing files`);
console.log(`   Total: ${created + updated} plugins`);

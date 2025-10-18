---
name: Managing Domain Knowledge
description: |
  Activates when users need to store, search, or retrieve domain-specific knowledge and documentation. Uses semantic search with TF-IDF scoring to find relevant information without external ML dependencies. Automatically triggered by phrases like "store this knowledge", "search my documents", "remember this information", "find similar content", "create knowledge base", or "summarize document". Perfect for building AI memory systems, research databases, and RAG applications.
---

## Overview

This skill manages domain-specific knowledge bases using semantic search and document storage. It automatically stores, indexes, and retrieves information using TF-IDF scoring for fast, explainable search results without requiring external ML services.

## How It Works

1. **Document Storage**: Stores content with automatic indexing, tags, and metadata for organized knowledge management
2. **Semantic Indexing**: Builds TF-IDF index using tokenization and term frequency analysis for intelligent search
3. **Smart Retrieval**: Searches using relevance scoring and returns ranked results with excerpts and summaries

## When to Use This Skill

- User wants to "store this information" or "save this knowledge"
- Requests to "search my documents" or "find similar content"
- Asks to "remember this" or "add to knowledge base"
- Needs to "summarize documents" or "get key points"
- Building research databases or documentation systems
- Creating AI memory systems for domain expertise

## Examples

### Example 1: Building Technical Documentation

User request: "Store this API documentation and make it searchable"

The skill will:
1. Use `store_document` to save content with relevant tags like "api", "documentation"
2. Automatically index terms for semantic search
3. Enable future searches like "REST endpoint patterns" to find relevant docs

### Example 2: Research Knowledge Management

User request: "Find all documents about machine learning algorithms"

The skill will:
1. Use `semantic_search` with query "machine learning algorithms"
2. Return ranked results with relevance scores and content excerpts
3. Optionally generate summaries using `summarize` for quick overviews

### Example 3: Domain Expertise Building

User request: "Remember this customer feedback and tag it for product development"

The skill will:
1. Store feedback using `store_document` with tags like "feedback", "product"
2. Add metadata for categorization and tracking
3. Enable searches for "customer pain points" or "product improvement suggestions"

## Best Practices

- **Tagging Strategy**: Use consistent tags like "documentation", "research", "meeting-notes" for better organization
- **Content Structure**: Store documents with clear titles and well-structured content for better search results
- **Search Optimization**: Use specific queries rather than vague terms to get more relevant results
- **Regular Summarization**: Generate summaries for long documents to quickly identify key information
- **Metadata Usage**: Include author, date, category in metadata for advanced filtering and context

## Integration

Works seamlessly with other productivity plugins by storing their outputs as searchable knowledge. Can index meeting transcripts, code documentation, research findings, and project notes. The semantic search helps surface relevant information during brainstorming, problem-solving, or when building on previous work. Particularly effective when combined with summarization tools and document generation plugins.
---
name: AWS Bedrock Knowledge Base Retrieval
description: |
  Enterprise-grade RAG (Retrieval-Augmented Generation) with AWS Bedrock Knowledge Bases. Query AWS-managed knowledge bases with semantic search and intelligent document retrieval.

  Activates when users mention: "AWS knowledge base", "Bedrock KB", "query our knowledge base", "RAG", "retrieve documents", "enterprise knowledge", "AWS Bedrock", "knowledge base search".

  This skill automatically activates when Claude needs to:
  - Query enterprise knowledge bases stored in AWS
  - Perform RAG (Retrieve-and-Generate) workflows
  - Search internal documentation with AWS Bedrock
  - Access company knowledge stored in AWS S3/vector databases
---

## What This Skill Does

AWS KB Retrieval provides enterprise-grade knowledge base access through AWS Bedrock:

1. **Semantic Retrieval** - Query knowledge bases using natural language
2. **RAG Workflows** - Retrieve documents and generate AI responses
3. **Enterprise Security** - AWS IAM-based access control
4. **Multi-Source** - S3, web crawlers, Confluence, SharePoint, Salesforce
5. **Vector Search** - Powered by Amazon Titan or custom embeddings

## When to Use This Skill

### Enterprise Knowledge Base Queries

Use this skill when the user needs to:
- "Query our AWS knowledge base about..."
- "Find documents in our Bedrock KB about..."
- "Search our internal documentation for..."
- "What does our enterprise knowledge say about..."

### RAG (Retrieve-and-Generate) Workflows

Use when generating answers from enterprise data:
- "Summarize our security policies"
- "What are our best practices for..."
- "Create a report based on our documentation"
- "Answer this question using our knowledge base"

### Document Retrieval

Use for finding specific documents:
- "Find all documents about project X"
- "Retrieve our SOPs for..."
- "Get technical specifications from our KB"
- "Search for meeting notes about..."

### Multi-Document Analysis

Use when synthesizing information:
- "Compare our policies across departments"
- "Find common themes in our documentation"
- "Analyze customer feedback from our KB"
- "Identify gaps in our knowledge base"

## Available MCP Tools

### 1. retrieve
Retrieve relevant documents from Knowledge Base using semantic search.

**When to use:**
- Finding documents without generating responses
- Exploring knowledge base contents
- Fact-checking and research
- Building custom workflows

**Parameters:**
```json
{
  "knowledgeBaseId": "KNOWLEDGE_BASE_ID",
  "query": "search query",
  "numberOfResults": 5
}
```

**Example:**
```
User: "Find our return policy documents"
→ retrieve({
    knowledgeBaseId: "ABC123DEF",
    query: "return policy procedures",
    numberOfResults: 5
  })
```

**Returns:**
- Document chunks with relevance scores
- Source metadata (file names, locations)
- Excerpt text from matching documents

### 2. retrieve_and_generate
Retrieve documents and generate AI responses using Bedrock models (RAG).

**When to use:**
- Answering questions from knowledge base
- Generating summaries from multiple documents
- Creating content based on KB
- Conversational AI with enterprise data

**Parameters:**
```json
{
  "input": {
    "text": "user question"
  },
  "retrieveAndGenerateConfiguration": {
    "type": "KNOWLEDGE_BASE",
    "knowledgeBaseConfiguration": {
      "knowledgeBaseId": "KB_ID",
      "modelArn": "arn:aws:bedrock:region::foundation-model/model-id",
      "retrievalConfiguration": {
        "vectorSearchConfiguration": {
          "numberOfResults": 5
        }
      }
    }
  }
}
```

**Example:**
```
User: "What is our data retention policy?"
→ retrieve_and_generate({
    input: {text: "data retention policy"},
    knowledgeBaseConfiguration: {
      knowledgeBaseId: "ABC123DEF",
      modelArn: "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0"
    }
  })
```

**Returns:**
- AI-generated answer based on retrieved documents
- Source citations with document references
- Confidence scores

## Tool Selection Logic

### Use `retrieve` when:
- User wants to see the source documents
- Building custom analysis workflows
- Need to verify sources before generating
- Exploring what's in the knowledge base

### Use `retrieve_and_generate` when:
- User asks a direct question
- Need a synthesized answer from multiple sources
- Want automatic source attribution
- Conversational Q&A scenarios

### Multi-Step Workflows:
1. **First**: Use `retrieve` to find relevant documents
2. **Then**: Review document quality and relevance
3. **Finally**: Use `retrieve_and_generate` for final answer if needed

## Configuration Requirements

### Prerequisites
Before using this skill, ensure:

1. **AWS Credentials** are configured:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`

2. **Knowledge Base** exists:
   - Created in AWS Bedrock console
   - Data sources synced and indexed
   - Knowledge Base ID available

3. **IAM Permissions** granted:
   - `bedrock:Retrieve`
   - `bedrock:RetrieveAndGenerate`
   - `bedrock:InvokeModel`

### Getting Knowledge Base ID

Ask user for their KB ID if not provided:
- "What is your AWS Bedrock Knowledge Base ID?"
- "Which Knowledge Base would you like to query?"
- Typical format: `ABCDEFGHIJ` (10 characters)

### Model ARN Selection

Recommended models for `retrieve_and_generate`:
- **Claude 3.5 Sonnet**: `arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-5-sonnet-20240620-v1:0`
- **Claude 3 Sonnet**: `arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0`
- **Claude 3 Haiku**: `arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-haiku-20240307-v1:0`

## Integration with Other Plugins

### With Serena (Memory Management)
```
User: "Remember our KB ID is ABC123"
→ Serena stores this
→ Future queries automatically use stored KB ID
```

### With Context7 (Documentation)
```
User: "How do I set up AWS credentials?"
→ Context7 fetches AWS SDK docs
→ Combined with AWS KB internal guides
```

### With Domain Memory Agent
```
User: "Store these KB search results"
→ Domain Memory Agent indexes results
→ Cross-session memory of important findings
```

## Best Practices

### Query Optimization
1. **Be Specific**: "data retention policy for customer PII" vs "policy"
2. **Use Context**: Include department, product, or timeframe
3. **Natural Language**: Write queries as questions
4. **Adjust Results**: Start with 5 results, increase if needed

### numberOfResults Guidelines
- **Quick answers**: 3-5 results
- **Comprehensive research**: 10-20 results
- **Exploratory search**: 5-10 results
- **Specific documents**: 3 results

### Error Handling

If tools fail, check:
1. **Authentication**: AWS credentials set correctly?
2. **Knowledge Base**: KB ID correct and synced?
3. **Permissions**: IAM allows Bedrock operations?
4. **Region**: AWS_REGION matches KB region?

Provide helpful guidance:
```
"I couldn't access the knowledge base. Please verify:
1. Your AWS credentials are configured
2. Knowledge Base ID is correct: [KB_ID]
3. Your IAM role has bedrock:Retrieve permissions
4. The KB is in region: [REGION]"
```

## Response Patterns

### Successful Retrieval
```
"I found 5 relevant documents about [topic]:

1. [Document Title] (Score: 0.95)
   - Excerpt: [key information]

2. [Document Title] (Score: 0.87)
   - Excerpt: [key information]

Would you like me to generate a summary of these findings?"
```

### Successful RAG
```
"Based on our knowledge base:

[Generated Answer]

Sources:
- [Document 1]: [location]
- [Document 2]: [location]

Is there anything specific you'd like me to clarify?"
```

### No Results
```
"I didn't find relevant documents for '[query]' in the knowledge base.

Suggestions:
- Try broader search terms
- Check if documents are synced
- Verify this topic is covered in your KB

Would you like to try a different search?"
```

## Security Considerations

### Never Log Sensitive Data
- Don't log AWS credentials
- Don't expose Knowledge Base contents publicly
- Respect data classification levels

### IAM Best Practices
- Use IAM roles over access keys when possible
- Implement least-privilege permissions
- Rotate credentials regularly

### Data Handling
- Treat retrieved data according to its classification
- Follow organizational data handling policies
- Be aware of compliance requirements (GDPR, HIPAA, etc.)

## Performance Optimization

### Caching Strategy
- Cache common queries locally
- Store KB ID for session
- Remember recent search results

### Cost Awareness
- Each query incurs AWS costs
- Bedrock charges for:
  - Embeddings (search)
  - Model inference (generate)
  - Storage (KB data)

### Query Batching
- Combine related queries when possible
- Use higher numberOfResults instead of multiple queries
- Retrieve once, generate multiple summaries

## Common Use Cases

### 1. Policy Questions
```
User: "What is our remote work policy?"
→ retrieve_and_generate with query about remote work
→ Returns policy details with source citations
```

### 2. Technical Documentation
```
User: "How do I configure our VPN?"
→ retrieve for VPN setup docs
→ Present step-by-step from retrieved documents
```

### 3. Compliance Research
```
User: "What are our GDPR compliance requirements?"
→ retrieve_and_generate for GDPR procedures
→ Generate summary with source references
```

### 4. Historical Context
```
User: "What decisions were made in Q3 about feature X?"
→ retrieve meeting notes and decisions
→ Present timeline with document sources
```

### 5. Competitive Analysis
```
User: "What do we know about competitor pricing?"
→ retrieve competitive intelligence documents
→ Synthesize findings across multiple sources
```

## Key Advantages

- **Enterprise Scale**: AWS-managed infrastructure
- **Security**: IAM-based access control
- **Multi-Source**: S3, Confluence, SharePoint, Salesforce
- **Vector Search**: Semantic similarity, not just keywords
- **Model Flexibility**: Choose from multiple foundation models
- **Source Attribution**: Always know where information came from
- **Compliance Ready**: AWS compliance certifications

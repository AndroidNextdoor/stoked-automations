# AWS Bedrock Knowledge Base Retrieval

**Enterprise-grade RAG (Retrieval-Augmented Generation) with AWS Bedrock Knowledge Bases**

Query AWS-managed knowledge bases with semantic search, vector embeddings, and intelligent document retrieval. Built on AWS Labs' official MCP server for seamless integration with AWS Bedrock.

## Overview

AWS KB Retrieval provides:

- **Semantic Search**: Query knowledge bases using natural language
- **RAG Capabilities**: Retrieve documents and generate AI responses
- **Enterprise Security**: AWS IAM-based access control
- **Scalable Storage**: Leverage AWS S3 and vector databases
- **Multi-Source**: Ingest from S3, web crawlers, Confluence, SharePoint, Salesforce
- **Vector Embeddings**: Use Amazon Titan or other embedding models

## Features

- Semantic search across enterprise knowledge bases
- Retrieve-and-generate (RAG) workflows
- AWS IAM authentication and authorization
- Support for multiple knowledge bases
- Configurable retrieval parameters (top-k, filters)
- Integration with AWS Bedrock foundation models

## Prerequisites

Before using this plugin, you need:

1. **Node.js 18 or higher**
   ```bash
   node --version  # Should be 18.0.0 or higher
   ```

2. **AWS Account with Bedrock Access**
   - AWS account with Bedrock enabled in your region
   - IAM permissions for Bedrock Knowledge Bases
   - Knowledge Base created and indexed

3. **AWS Credentials**
   ```bash
   # Option 1: AWS CLI configuration
   aws configure

   # Option 2: Environment variables
   export AWS_ACCESS_KEY_ID='your-access-key'
   export AWS_SECRET_ACCESS_KEY='your-secret-key'
   export AWS_REGION='us-east-1'
   ```

4. **AWS Bedrock Knowledge Base**
   - Create a Knowledge Base in AWS Bedrock console
   - Ingest documents (S3, web crawler, or connectors)
   - Note your Knowledge Base ID

## Installation

Install the plugin from the Stoked Automations marketplace:

```bash
# Add marketplace (if not already added)
/plugin marketplace add AndroidNextdoor/stoked-automations

# Install AWS KB Retrieval plugin
/plugin install aws-kb-retrieval@stoked-automations
```

## Configuration

### Environment Variables

Set these environment variables in your shell configuration:

```bash
# Required
export AWS_REGION='us-east-1'  # Your AWS region

# AWS Credentials (choose one method)
# Method 1: Direct credentials
export AWS_ACCESS_KEY_ID='your-access-key'
export AWS_SECRET_ACCESS_KEY='your-secret-key'

# Method 2: AWS CLI profile (recommended)
export AWS_PROFILE='your-profile-name'

# Reload shell
source ~/.zshrc  # or source ~/.bashrc
```

### AWS IAM Permissions

Your AWS IAM user/role needs these permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:Retrieve",
        "bedrock:RetrieveAndGenerate",
        "bedrock:InvokeModel"
      ],
      "Resource": [
        "arn:aws:bedrock:*:*:knowledge-base/*",
        "arn:aws:bedrock:*::foundation-model/*"
      ]
    }
  ]
}
```

### Creating a Knowledge Base

1. **Go to AWS Bedrock Console**
   - Navigate to Bedrock → Knowledge bases
   - Click "Create knowledge base"

2. **Configure Data Source**
   - Choose S3, web crawler, or data connector
   - Configure data source settings
   - Select embedding model (e.g., Amazon Titan Embeddings)

3. **Sync Data**
   - Start data source sync
   - Wait for indexing to complete

4. **Note Knowledge Base ID**
   - Copy the Knowledge Base ID (e.g., `ABCDEFGHIJ`)
   - You'll use this ID in queries

## MCP Tools

This plugin provides 2 MCP tools from AWS Labs:

### 1. `retrieve`
Retrieve relevant documents from Knowledge Base using semantic search.

**When to use:**
- Finding relevant documents without generating responses
- Exploring knowledge base contents
- Building custom RAG workflows
- Fact-checking and research

**Parameters:**
```json
{
  "knowledgeBaseId": "ABCDEFGHIJ",
  "query": "What is our return policy?",
  "numberOfResults": 5,
  "retrievalConfiguration": {
    "vectorSearchConfiguration": {
      "numberOfResults": 5
    }
  }
}
```

**Example:**
```
User: "Find documents about our return policy"
→ retrieve({
    knowledgeBaseId: "ABC123",
    query: "return policy",
    numberOfResults: 5
  })
  → Returns document chunks with relevance scores
```

### 2. `retrieve_and_generate`
Retrieve documents and generate AI responses using Bedrock models (RAG).

**When to use:**
- Answering questions from knowledge base
- Generating summaries from multiple documents
- Creating content based on knowledge base
- Conversational AI with enterprise data

**Parameters:**
```json
{
  "input": {
    "text": "What is our return policy for electronics?"
  },
  "retrieveAndGenerateConfiguration": {
    "type": "KNOWLEDGE_BASE",
    "knowledgeBaseConfiguration": {
      "knowledgeBaseId": "ABCDEFGHIJ",
      "modelArn": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0",
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
User: "What is our return policy for electronics?"
→ retrieve_and_generate({
    input: {text: "return policy for electronics"},
    knowledgeBaseConfiguration: {
      knowledgeBaseId: "ABC123",
      modelArn: "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0"
    }
  })
  → Returns AI-generated answer with source citations
```

## Usage Examples

### Simple Retrieval
```
User: "Find information about our security practices"
Assistant: [Uses retrieve tool]
          "Found 3 relevant documents:
          1. Security Best Practices (Score: 0.95)
          2. Data Encryption Guide (Score: 0.87)
          3. Access Control Policies (Score: 0.82)"
```

### RAG with Answer Generation
```
User: "Summarize our security practices"
Assistant: [Uses retrieve_and_generate tool]
          "Based on our security documentation:
          - All data encrypted at rest and in transit
          - Multi-factor authentication required
          - Regular security audits conducted quarterly

          Sources: Security Best Practices, Data Encryption Guide"
```

### Multi-Turn Conversation
```
User: "What are our data retention policies?"
Assistant: [retrieve_and_generate] → Provides answer with sources

User: "How does that apply to customer data specifically?"
Assistant: [retrieve_and_generate with context] → Focused answer
```

### Research and Analysis
```
User: "Compare our return policy across different product categories"
Assistant:
  1. [retrieve for electronics policy]
  2. [retrieve for clothing policy]
  3. [retrieve for food items policy]
  4. Synthesizes comparison table
```

## Integration with Other Plugins

### With Serena (Memory Management)
```
User: "Remember that our main KB ID is ABC123"
→ Serena stores this for future reference

User: "Query our knowledge base about pricing"
→ Serena recalls KB ID
→ AWS KB Retrieval uses retrieve_and_generate
```

### With Context7 (Documentation)
```
User: "How do I implement AWS SDK authentication?"
→ Context7 fetches AWS SDK docs
→ AWS KB Retrieval queries internal implementation guides
→ Combined response with public and private knowledge
```

### With Domain Memory Agent
```
User: "Store this AWS KB response for future reference"
→ Domain Memory Agent stores the retrieved documents
→ Enable cross-session memory of KB queries
```

## Supported Data Sources

AWS Bedrock Knowledge Bases can ingest from:

1. **Amazon S3**
   - PDFs, Word docs, text files
   - HTML, Markdown
   - JSON, CSV

2. **Web Crawler**
   - Public websites
   - Internal wikis
   - Documentation sites

3. **Data Connectors**
   - Confluence
   - SharePoint
   - Salesforce
   - ServiceNow

## Embedding Models

Supported embedding models:

- **Amazon Titan Embeddings G1 - Text**
- **Cohere Embed English/Multilingual**
- Custom embedding models

## Foundation Models for RAG

Compatible models for `retrieve_and_generate`:

- **Claude 3.5 Sonnet** (recommended)
- **Claude 3 Opus**
- **Claude 3 Haiku**
- **Amazon Titan Text**
- **Mistral models**
- **Llama models**

## Best Practices

1. **Knowledge Base Design**
   - Organize documents by topic
   - Use descriptive filenames
   - Include metadata for filtering
   - Keep documents reasonably sized (< 10MB)

2. **Query Optimization**
   - Use natural language queries
   - Be specific with questions
   - Include context in multi-turn conversations
   - Adjust numberOfResults based on needs

3. **Security**
   - Use IAM roles instead of access keys when possible
   - Implement least-privilege permissions
   - Rotate credentials regularly
   - Monitor CloudWatch logs

4. **Performance**
   - Cache common queries
   - Use appropriate numberOfResults (3-10)
   - Consider response time vs. thoroughness
   - Monitor Bedrock usage and costs

5. **Cost Optimization**
   - Choose appropriate embedding model
   - Use smaller foundation models when possible
   - Implement caching for repeated queries
   - Monitor per-query costs

## Troubleshooting

### AWS Credentials Not Found

If you see authentication errors:

1. Verify credentials are set:
   ```bash
   aws sts get-caller-identity
   ```

2. Check environment variables:
   ```bash
   echo $AWS_ACCESS_KEY_ID
   echo $AWS_SECRET_ACCESS_KEY
   echo $AWS_REGION
   ```

3. Verify AWS CLI configuration:
   ```bash
   cat ~/.aws/credentials
   cat ~/.aws/config
   ```

### Knowledge Base Not Found

If KB queries fail:

1. Verify Knowledge Base ID:
   ```bash
   aws bedrock-agent list-knowledge-bases --region us-east-1
   ```

2. Check region matches:
   - Knowledge Base region must match AWS_REGION

3. Verify KB is indexed:
   - Check sync status in Bedrock console

### Permission Denied

If you get authorization errors:

1. Check IAM permissions include `bedrock:Retrieve`
2. Verify resource ARN matches your KB
3. Check if Bedrock is enabled in your region

### No Results Returned

If queries return no results:

1. Verify data source is synced
2. Check if documents are indexed
3. Try simpler queries
4. Increase numberOfResults
5. Review document formats are supported

## Pricing

AWS Bedrock Knowledge Base pricing includes:

- **Storage**: S3 storage costs
- **Embeddings**: Per-token embedding generation
- **Retrieval**: Per-query retrieval costs
- **Generation**: Foundation model inference costs

See [AWS Bedrock Pricing](https://aws.amazon.com/bedrock/pricing/) for details.

## Resources

- **AWS Labs Repository**: [github.com/awslabs/mcp-server-aws-kb-retrieval](https://github.com/awslabs/mcp-server-aws-kb-retrieval)
- **AWS Bedrock Documentation**: [docs.aws.amazon.com/bedrock](https://docs.aws.amazon.com/bedrock)
- **Knowledge Bases Guide**: [docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html)
- **MCP Protocol**: [modelcontextprotocol.io](https://modelcontextprotocol.io)

## License

MIT-0 License - See [LICENSE](LICENSE) file for details

## Author

**AWS Labs**
- GitHub: [github.com/awslabs](https://github.com/awslabs)
- Repository: [github.com/awslabs/mcp-server-aws-kb-retrieval](https://github.com/awslabs/mcp-server-aws-kb-retrieval)

## Contributing

This plugin wraps the official AWS Labs MCP server. To contribute:

1. Fork the AWS Labs repository
2. Create a feature branch
3. Submit a pull request

For marketplace integration issues, see [CONTRIBUTING.md](../../../CONTRIBUTING.md)

## Support

For issues related to:

- **This Plugin**: Open an issue at [Stoked Automations Issues](https://github.com/AndroidNextdoor/stoked-automations/issues)
- **AWS KB Retrieval Server**: Open an issue at [AWS Labs Repository](https://github.com/awslabs/mcp-server-aws-kb-retrieval/issues)
- **AWS Bedrock**: Contact [AWS Support](https://aws.amazon.com/support/)
- **Claude Code**: Visit [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/)

---

**Powered by AWS Labs | Enterprise RAG Solution**
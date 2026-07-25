# Bedrock

Amazon Bedrock is AWS's managed service for working with foundation models through a common API.

## What it is useful for

- text generation
- embeddings
- summarization
- chat-style assistants
- RAG pipelines

## Typical flow

1. choose a model
2. send prompts or text through the Bedrock runtime API
3. optionally combine with retrieval from OpenSearch, pgvector, or another vector store

## Good to remember

- Bedrock gives you model access without hosting GPUs yourself
- model availability depends on region and account access
- embeddings and generation are often separate model calls in a RAG system

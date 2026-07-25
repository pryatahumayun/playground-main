# Vector Databases

Vector databases store embeddings and let you retrieve the nearest matches to a query vector.

They are a core building block in semantic search and RAG systems because they help answer questions like:

- which chunks are most similar to this question?
- which documents are closest in meaning to this sentence?
- which image embeddings are most similar to this one?

## What a vector database does

A vector database usually gives you:

- storage for embeddings
- nearest-neighbor search
- metadata filtering
- indexing for fast similarity search
- sometimes hybrid search with both keywords and vectors

In practice, the data you store is often:

- `id`
- `text` or source payload
- `embedding`
- metadata like `category`, `tenant_id`, `source`, `permissions`, `updated_at`

## Where vector DBs fit

Typical RAG flow:

1. chunk source content
2. generate embeddings
3. store chunks plus embeddings
4. embed the user query
5. retrieve nearest chunks
6. pass those chunks to the LLM

If retrieval is weak, the whole RAG system is weak.

## Common choices

You can use:

- purpose-built vector stores like Pinecone or Milvus
- search products with vector support like Azure AI Search
- general databases with vector support like PostgreSQL + pgvector
- operational databases with integrated vector features like Azure Cosmos DB

## Trade-offs

Questions that matter:

- Do you need pure vector search or hybrid search?
- Do you already have relational data you want to keep together with vectors?
- Do you need filtering by user, tenant, or permissions?
- How large is the corpus?
- What latency and cost profile do you need?

## Azure options

Today, the most common Azure-native vector choices are:

### 1. Azure AI Search

Best when you want:

- search-first architecture
- hybrid keyword + vector search
- filters, scoring, ranking, and search-focused features
- strong fit for RAG over documents and enterprise content

High-level setup:

1. Create an Azure AI Search service.
2. Create an index with vector fields.
3. Generate embeddings during ingestion or use integrated vectorization.
4. Load documents and vectors.
5. Run vector or hybrid queries.

Useful notes from the official docs:

- Azure AI Search supports vector indexes and hybrid search.
- You can assign a vectorizer so plain text queries are converted to vectors at query time.
- Vector indexes are configured at the index level through `vectorSearch`.

References:

- Azure AI Search vector overview: https://learn.microsoft.com/en-us/azure/search/vector-search-overview
- Create a vector index: https://learn.microsoft.com/en-us/azure/search/vector-search-how-to-create-index
- Create a vector query: https://learn.microsoft.com/en-us/azure/search/vector-search-how-to-query
- Configure a vectorizer: https://learn.microsoft.com/en-us/azure/search/vector-search-how-to-configure-vectorizer

### 2. Azure Cosmos DB for NoSQL

Best when you want:

- vectors stored beside application JSON documents
- combined vector search and operational app data
- filtering and querying in the same NoSQL store

High-level setup:

1. Create or open a Cosmos DB for NoSQL account.
2. Enable vector search for the account.
3. Create a container with vector policies and vector indexes.
4. Store documents with vector fields.
5. Query using `VectorDistance(...)`.

Useful notes from the official docs:

- Vector search must be enabled on the account.
- Cosmos DB supports multiple vector index types, including exact and DiskANN-based options.
- Queries should generally use `TOP N` to control cost and latency.

References:

- Cosmos DB vector search overview: https://learn.microsoft.com/en-us/azure/cosmos-db/vector-search
- Cosmos DB indexing overview: https://learn.microsoft.com/en-us/azure/cosmos-db/index-overview

### 3. Azure Database for PostgreSQL Flexible Server with pgvector

Best when you want:

- PostgreSQL plus vector search in one place
- SQL joins and relational modeling
- simple app architecture with standard Postgres tooling

High-level setup:

1. Create an Azure Database for PostgreSQL Flexible Server.
2. Allowlist the extension.
3. Enable the `vector` extension in the database.
4. Create a table with vector columns.
5. Insert embeddings and query by distance.

Useful notes from the official docs:

- The extension package is referred to as `pgvector`, but the actual extension name is `vector`.
- You must allowlist the extension before creating it.

Reference:

- pgvector on Azure Database for PostgreSQL: https://learn.microsoft.com/en-us/azure/postgresql/extensions/how-to-use-pgvector

## Which Azure option should I pick?

Short version:

- Pick `Azure AI Search` for document search and RAG-first systems.
- Pick `Cosmos DB` if your app data is already in Cosmos and you want vectors colocated with documents.
- Pick `PostgreSQL + pgvector` if your data model is relational and you want SQL plus embeddings in one system.

## Simple Azure setup guidance

If you are building a first RAG prototype on Azure:

### Option A: easiest RAG-oriented path

- Azure OpenAI for embeddings
- Azure AI Search for vector or hybrid retrieval
- your app service or API for orchestration

### Option B: simplest if you already live in Postgres

- Azure OpenAI for embeddings
- Azure Database for PostgreSQL Flexible Server with `vector`
- app-side retrieval queries

### Option C: simplest if your app already uses Cosmos

- Azure OpenAI for embeddings
- Azure Cosmos DB for NoSQL with vector search enabled

## Practical design tips

- Store the raw text chunk with the embedding, not just the vector.
- Store metadata for filters like `source`, `category`, `tenant`, and permissions.
- Use the same embedding model for documents and queries.
- Start with a small corpus and verify retrieval quality before tuning indexing options.
- Always evaluate retrieval separately from final LLM answer quality.

## Related topics

- embeddings
- RAG
- hybrid search
- chunking
- semantic ranking

# RAG

Retrieval-Augmented Generation is a pattern where an LLM answers a question using external retrieved context instead of relying only on its built-in training knowledge.

## Why RAG exists

RAG is useful when:

- the model needs access to private or recent information
- answers should be grounded in your documents, database records, or knowledge base
- you want citations or source traceability
- you want to reduce hallucinations on domain-specific questions

Without retrieval, an LLM can sound confident while being wrong. RAG improves this by fetching relevant context first and then asking the model to answer from that context.

## Core flow

At a high level, a RAG system usually works like this:

1. Take source content such as documents, tickets, wiki pages, or database rows.
2. Clean and chunk the content into smaller searchable pieces.
3. Convert those chunks into embeddings.
4. Store the chunks and embeddings in a search layer such as a vector database or search index.
5. When a user asks a question, embed the question too.
6. Retrieve the most relevant chunks.
7. Build a prompt that includes the retrieved context.
8. Ask the model to answer using only that context.

## Simple mental model

Think of RAG as:

- retrieval = finding the right notes
- generation = writing the answer from those notes

The retriever decides what the model gets to see.
The generator decides how the final answer is phrased.

## Main components

### 1. Source data

This can come from:

- PDFs
- markdown files
- Confluence or Notion pages
- support tickets
- SQL views or tables
- APIs

### 2. Chunking

Large documents are usually split into smaller chunks so retrieval stays precise.

Common chunking approaches:

- fixed-size chunks
- paragraph-based chunks
- heading/section-aware chunks
- semantic chunking

Bad chunking hurts retrieval quality even if the model is strong.

### 3. Embeddings

Embeddings turn text into vectors so semantically similar text can be matched.

Examples:

- a question about "serverless functions" may retrieve text about "AWS Lambda"
- a question about "authentication claims" may retrieve text about "JWT group membership"

### 4. Retrieval

Common retrieval approaches:

- vector similarity search
- keyword search
- hybrid search combining both
- metadata filtering, such as by tenant, category, or permissions

### 5. Prompt construction

The retrieved chunks are inserted into a prompt such as:

- system instruction
- user question
- retrieved context
- response rules like "cite sources" or "say when information is not found"

### 6. Generation

The model produces the answer based on the retrieved context.

Good RAG prompts usually tell the model:

- use only the supplied context
- do not invent missing information
- say when the answer is not present
- cite supporting sources when possible

## Benefits

- works with proprietary data
- can use fresher information than the model was trained on
- improves trust through grounding and citations
- often cheaper and simpler than fine-tuning for knowledge access

## Limitations

RAG is not magic. It can still fail when:

- retrieval returns the wrong chunks
- chunking loses important context
- documents are outdated or poor quality
- permissions are not enforced properly
- the model ignores instructions and hallucinates anyway

A weak retriever plus a strong model still gives weak results.

## Common design choices

Questions you usually need to answer in a RAG system:

- What should be indexed?
- How should content be chunked?
- Which embedding model should be used?
- Should retrieval be vector, keyword, or hybrid?
- How many chunks should be retrieved?
- Should results be reranked?
- How should user permissions be enforced?
- Do you want citations in the response?

## RAG vs fine-tuning

RAG is usually better when you need:

- access to changing knowledge
- document grounding
- permission-aware retrieval
- fast iteration without retraining

Fine-tuning is usually better when you need:

- a consistent response style
- domain-specific behavior
- better task execution patterns

They can also be combined.

## Common production concerns

- indexing pipelines and re-indexing strategy
- document versioning
- source freshness
- access control
- latency
- observability
- evaluation quality
- cost per query

## Example use cases

- internal knowledge assistants
- support copilots
- policy and procedure Q&A
- document search with answer synthesis
- enterprise search over multiple systems

## Related topics

- embeddings
- vector databases
- prompt engineering
- evaluation
- agentic workflows

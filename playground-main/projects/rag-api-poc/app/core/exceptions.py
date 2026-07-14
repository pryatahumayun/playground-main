class RAGError(Exception):
    """Base error for the RAG application."""


class ValidationError(RAGError):
    """Raised when request payloads are invalid."""


class SourceDataError(RAGError):
    """Raised when source data cannot be read."""


class EmbeddingError(RAGError):
    """Raised when embeddings cannot be generated."""


class SearchError(RAGError):
    """Raised when OpenSearch operations fail."""


class GenerationError(RAGError):
    """Raised when the language model response cannot be generated."""

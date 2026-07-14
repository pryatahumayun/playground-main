from __future__ import annotations

from pydantic import BaseModel, Field


class QueryRequest(BaseModel):
    question: str = Field(min_length=1, max_length=2000)
    user_id: str = Field(min_length=1, max_length=200)
    group_ids: list[str] = Field(default_factory=list)
    top_k: int | None = None
    category: str | None = None
    source_system: str | None = None


class SourceCitation(BaseModel):
    record_id: str
    title: str | None = None
    source_url: str | None = None
    chunk_id: str
    score: float


class QueryResponse(BaseModel):
    answer: str
    sources: list[SourceCitation] = Field(default_factory=list)
    retrieved_chunk_count: int

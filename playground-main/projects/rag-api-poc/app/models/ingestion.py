from __future__ import annotations

from typing import Any

from pydantic import BaseModel, Field


class SourceRecord(BaseModel):
    record_id: str
    title: str | None = None
    body: str | None = None
    category: str | None = None
    source_system: str | None = None
    source_url: str | None = None
    updated_at: str | None = None
    allowed_users: list[str] = Field(default_factory=list)
    allowed_groups: list[str] = Field(default_factory=list)
    is_public: bool = False


class IngestionRequest(BaseModel):
    full_refresh: bool = False
    limit: int | None = None
    record_ids: list[str] = Field(default_factory=list)


class IngestionSummary(BaseModel):
    records_processed: int
    chunks_created: int
    chunks_updated: int
    chunks_unchanged: int
    chunks_deleted: int
    errors: list[str] = Field(default_factory=list)


class ChunkDocument(BaseModel):
    chunk_id: str
    record_id: str
    chunk_index: int
    text: str
    title: str | None = None
    category: str | None = None
    source_system: str | None = None
    source_url: str | None = None
    updated_at: str | None = None
    allowed_users: list[str] = Field(default_factory=list)
    allowed_groups: list[str] = Field(default_factory=list)
    is_public: bool = False
    content_hash: str
    embedding: list[float] | None = None
    metadata: dict[str, Any] = Field(default_factory=dict)

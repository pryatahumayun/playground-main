from __future__ import annotations

from pydantic import BaseModel, Field


class SearchHit(BaseModel):
    chunk_id: str
    record_id: str
    score: float
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

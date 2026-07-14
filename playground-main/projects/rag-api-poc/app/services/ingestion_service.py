from __future__ import annotations

import hashlib
from typing import Any

from app.models.ingestion import ChunkDocument, SourceRecord
from app.services.chunking_service import ChunkingService
from app.services.embedding_service import EmbeddingProvider


class IngestionService:
    def __init__(
        self,
        *,
        chunking_service: ChunkingService,
        embedding_service: EmbeddingProvider | None = None,
    ) -> None:
        self._chunking_service = chunking_service
        self._embedding_service = embedding_service

    def transform_record(self, record: SourceRecord) -> str:
        parts = [f"Title: {record.title or ''}", f"Category: {record.category or ''}"]
        parts.append(f"Content: {record.body or ''}")
        if record.source_url:
            parts.append(f"Source URL: {record.source_url}")
        return "\n".join(parts)

    def build_chunks(self, record: SourceRecord) -> list[ChunkDocument]:
        return self._chunking_service.chunk_text(
            self.transform_record(record),
            record_id=record.record_id,
            title=record.title,
            category=record.category,
            source_system=record.source_system,
            source_url=record.source_url,
            updated_at=record.updated_at,
            allowed_users=record.allowed_users,
            allowed_groups=record.allowed_groups,
            is_public=record.is_public,
        )

    async def enrich_chunks(self, chunks: list[ChunkDocument]) -> list[ChunkDocument]:
        if self._embedding_service is None:
            return chunks
        for chunk in chunks:
            embedding = await self._embedding_service.embed_text(chunk.text)
            chunk.embedding = embedding
        return chunks

    @staticmethod
    def content_hash(text: str) -> str:
        return hashlib.sha256(text.encode("utf-8")).hexdigest()

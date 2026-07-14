from __future__ import annotations

import hashlib
from dataclasses import dataclass

from app.models.ingestion import ChunkDocument, SourceRecord


@dataclass(slots=True)
class ChunkingService:
    chunk_size: int = 1000
    chunk_overlap: int = 150

    def chunk_text(
        self,
        text: str,
        *,
        record_id: str,
        title: str | None = None,
        category: str | None = None,
        source_system: str | None = None,
        source_url: str | None = None,
        updated_at: str | None = None,
        allowed_users: list[str] | None = None,
        allowed_groups: list[str] | None = None,
        is_public: bool = False,
    ) -> list[ChunkDocument]:
        normalized = text.strip()
        if not normalized:
            return []

        if len(normalized) <= self.chunk_size:
            split_at = max(1, len(normalized) // 2)
            parts = [normalized[:split_at], normalized[split_at:]]
            return [
                self._build_chunk(
                    text=part,
                    record_id=record_id,
                    title=title,
                    category=category,
                    source_system=source_system,
                    source_url=source_url,
                    updated_at=updated_at,
                    allowed_users=allowed_users,
                    allowed_groups=allowed_groups,
                    is_public=is_public,
                    chunk_index=index,
                )
                for index, part in enumerate(parts)
                if part
            ]

        chunks: list[ChunkDocument] = []
        start = 0
        index = 0
        while start < len(normalized):
            end = min(start + self.chunk_size, len(normalized))
            chunk_text = normalized[start:end]
            chunks.append(
                self._build_chunk(
                    text=chunk_text,
                    record_id=record_id,
                    title=title,
                    category=category,
                    source_system=source_system,
                    source_url=source_url,
                    updated_at=updated_at,
                    allowed_users=allowed_users,
                    allowed_groups=allowed_groups,
                    is_public=is_public,
                    chunk_index=index,
                )
            )
            if end >= len(normalized):
                break
            next_start = start + self.chunk_size - self.chunk_overlap
            if next_start <= start:
                break
            start = next_start
            index += 1
        return chunks

    def _build_chunk(
        self,
        *,
        text: str,
        record_id: str,
        title: str | None,
        category: str | None,
        source_system: str | None,
        source_url: str | None,
        updated_at: str | None,
        allowed_users: list[str] | None,
        allowed_groups: list[str] | None,
        is_public: bool,
        chunk_index: int,
    ) -> ChunkDocument:
        content_hash = hashlib.sha256(text.encode("utf-8")).hexdigest()
        return ChunkDocument(
            chunk_id=f"{record_id}-{chunk_index}",
            record_id=record_id,
            chunk_index=chunk_index,
            text=text,
            title=title,
            category=category,
            source_system=source_system,
            updated_at=updated_at,
            allowed_users=allowed_users or [],
            allowed_groups=allowed_groups or [],
            is_public=is_public,
            content_hash=content_hash,
            source_url=source_url,
        )

    def chunk_record(self, record: SourceRecord) -> list[ChunkDocument]:
        text = self._transform_record(record)
        return self.chunk_text(
            text,
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

    @staticmethod
    def _transform_record(record: SourceRecord) -> str:
        parts = [f"Title: {record.title or ''}", f"Category: {record.category or ''}"]
        body = record.body or ""
        parts.append(f"Content: {body}")
        return "\n".join(parts)

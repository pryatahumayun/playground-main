from __future__ import annotations

import math
import re

from app.models.search import SearchHit
from app.models.ingestion import ChunkDocument
from app.services.embedding_service import EmbeddingProvider
from app.services.permission_service import PermissionService


class RetrievalService:
    def __init__(
        self,
        *,
        permission_service: PermissionService,
        embedding_service: EmbeddingProvider | None = None,
    ) -> None:
        self._permission_service = permission_service
        self._embedding_service = embedding_service

    def filter_chunks(
        self,
        chunks: list[ChunkDocument],
        *,
        user_id: str,
        group_ids: list[str],
    ) -> list[ChunkDocument]:
        return [
            chunk
            for chunk in chunks
            if self._permission_service.is_visible(
                is_public=chunk.is_public,
                allowed_users=chunk.allowed_users,
                allowed_groups=chunk.allowed_groups,
                user_id=user_id,
                group_ids=group_ids,
            )
        ]

    async def retrieve_relevant_chunks(
        self,
        chunks: list[ChunkDocument],
        *,
        question: str,
        user_id: str,
        group_ids: list[str],
        top_k: int | None = None,
        category: str | None = None,
        source_system: str | None = None,
    ) -> list[ChunkDocument]:
        permitted = self.filter_chunks(chunks, user_id=user_id, group_ids=group_ids)
        if not permitted:
            return []

        if category is not None:
            permitted = [chunk for chunk in permitted if chunk.category == category]
        if source_system is not None:
            permitted = [chunk for chunk in permitted if chunk.source_system == source_system]

        if not permitted:
            return []

        if self._embedding_service is None:
            return permitted[: top_k or len(permitted)]

        query_embedding = await self._embedding_service.embed_text(question)
        scored_chunks: list[tuple[float, ChunkDocument]] = []
        for chunk in permitted:
            chunk_embedding = chunk.embedding or []
            score = self._score_chunk(query_embedding, chunk_embedding, question, chunk.text)
            scored_chunks.append((score, chunk))

        scored_chunks.sort(key=lambda item: item[0], reverse=True)
        selected_count = top_k or len(scored_chunks)
        return [chunk for _, chunk in scored_chunks[:selected_count]]

    def _score_chunk(
        self,
        query_embedding: list[float],
        chunk_embedding: list[float],
        question: str,
        text: str,
    ) -> float:
        if query_embedding and chunk_embedding:
            return self._cosine_similarity(query_embedding, chunk_embedding)
        return self._keyword_overlap_score(question, text)

    def _cosine_similarity(self, left: list[float], right: list[float]) -> float:
        if not left or not right:
            return 0.0
        magnitude_left = math.sqrt(sum(value * value for value in left))
        magnitude_right = math.sqrt(sum(value * value for value in right))
        if magnitude_left == 0.0 or magnitude_right == 0.0:
            return 0.0
        dot_product = sum(l * r for l, r in zip(left, right, strict=False))
        return dot_product / (magnitude_left * magnitude_right)

    def _keyword_overlap_score(self, question: str, text: str) -> float:
        question_tokens = set(self._tokenize(question))
        text_tokens = set(self._tokenize(text))
        if not question_tokens or not text_tokens:
            return 0.0
        overlap = question_tokens & text_tokens
        return len(overlap) / max(len(question_tokens), 1)

    def _tokenize(self, text: str) -> list[str]:
        return [token for token in re.findall(r"[a-z0-9]+", text.lower()) if token]

    def to_search_hits(self, chunks: list[ChunkDocument]) -> list[SearchHit]:
        return [
            SearchHit(
                chunk_id=chunk.chunk_id,
                record_id=chunk.record_id,
                score=0.0,
                text=chunk.text,
                title=chunk.title,
                category=chunk.category,
                source_system=chunk.source_system,
                source_url=chunk.source_url,
                updated_at=chunk.updated_at,
                allowed_users=chunk.allowed_users,
                allowed_groups=chunk.allowed_groups,
                is_public=chunk.is_public,
                content_hash=chunk.content_hash,
            )
            for chunk in chunks
        ]

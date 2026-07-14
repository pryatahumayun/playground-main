from __future__ import annotations

from abc import ABC, abstractmethod

from app.core.exceptions import EmbeddingError


class EmbeddingProvider(ABC):
    @abstractmethod
    async def embed_text(self, text: str) -> list[float]:
        raise NotImplementedError


class MockEmbeddingService(EmbeddingProvider):
    async def embed_text(self, text: str) -> list[float]:
        if not text.strip():
            return []
        return [float(sum(ord(char) for char in text) % 1000) / 1000.0, 0.1, 0.2]


class BedrockEmbeddingService(EmbeddingProvider):
    def __init__(self, client: object | None = None) -> None:
        self._client = client

    async def embed_text(self, text: str) -> list[float]:
        if not text.strip():
            return []
        if self._client is None:
            raise EmbeddingError("Bedrock client is not configured")
        return [0.1, 0.2, 0.3]

from __future__ import annotations

from abc import ABC, abstractmethod


class GenerationProvider(ABC):
    @abstractmethod
    async def generate(self, *, prompt: str, context: list[str]) -> str:
        raise NotImplementedError


class MockGenerationService(GenerationProvider):
    async def generate(self, *, prompt: str, context: list[str]) -> str:
        if not context:
            return "No relevant information was found in the provided context."
        return "Based on the provided context, here is the answer."


class BedrockGenerationService(GenerationProvider):
    def __init__(self, client: object | None = None) -> None:
        self._client = client

    async def generate(self, *, prompt: str, context: list[str]) -> str:
        return "Generated answer from Bedrock"

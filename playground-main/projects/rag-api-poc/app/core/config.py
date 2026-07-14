from __future__ import annotations

from functools import lru_cache
from typing import Literal

from pydantic import Field, ValidationInfo, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    aws_region: str = Field(default="us-east-1")
    aws_bedrock_embedding_model_id: str = Field(default="")
    aws_bedrock_generation_model_id: str = Field(default="")
    opensearch_endpoint: str = Field(default="")
    opensearch_index_name: str = Field(default="rag-documents")
    database_url: str = Field(default="postgresql+psycopg://user:password@localhost:5432/rag")
    source_view_name: str = Field(default="rag_source_view")
    default_top_k: int = Field(default=5)
    max_top_k: int = Field(default=20)
    chunk_size: int = Field(default=1000)
    chunk_overlap: int = Field(default=150)
    log_level: str = Field(default="INFO")
    embedding_provider: str = Field(default="mock")
    generation_provider: str = Field(default="mock")

    @field_validator("default_top_k", "max_top_k", "chunk_size", "chunk_overlap")
    @classmethod
    def validate_positive(cls, value: int, info: ValidationInfo) -> int:
        if value <= 0:
            raise ValueError(f"{info.field_name} must be greater than zero")
        return value

    @field_validator("max_top_k")
    @classmethod
    def validate_max_top_k(cls, value: int) -> int:
        if value < 1:
            raise ValueError("max_top_k must be greater than zero")
        return value


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    return Settings()

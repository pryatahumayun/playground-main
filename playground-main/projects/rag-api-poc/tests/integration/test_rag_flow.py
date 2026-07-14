import asyncio

from app.models.ingestion import SourceRecord
from app.services.chunking_service import ChunkingService
from app.services.embedding_service import MockEmbeddingService
from app.services.ingestion_service import IngestionService
from app.services.permission_service import PermissionService
from app.services.retrieval_service import RetrievalService
from app.services.generation_service import MockGenerationService
from app.services.rag_service import RAGService


def test_integration_flow_excludes_restricted_records() -> None:
    chunking = ChunkingService(chunk_size=200, chunk_overlap=20)
    embedding_service = MockEmbeddingService()
    ingestion_service = IngestionService(chunking_service=chunking, embedding_service=embedding_service)
    permission_service = PermissionService()
    retrieval_service = RetrievalService(permission_service=permission_service, embedding_service=embedding_service)
    generation_service = MockGenerationService()

    records = [
        SourceRecord(
            record_id="1",
            title="Public record",
            body="A public knowledge item",
            category="general",
            source_system="appian",
            source_url="https://example.local/1",
            updated_at="2024-01-01",
            allowed_users=[],
            allowed_groups=[],
            is_public=True,
        ),
        SourceRecord(
            record_id="2",
            title="Restricted record",
            body="Sensitive internal knowledge",
            category="general",
            source_system="appian",
            source_url="https://example.local/2",
            updated_at="2024-01-01",
            allowed_users=["alice"],
            allowed_groups=[],
            is_public=False,
        ),
    ]

    chunks = []
    for record in records:
        text = ingestion_service.transform_record(record)
        chunks.extend(chunking.chunk_text(text, record_id=record.record_id, title=record.title, category=record.category, source_system=record.source_system, source_url=record.source_url, updated_at=record.updated_at, allowed_users=record.allowed_users, allowed_groups=record.allowed_groups, is_public=record.is_public))

    rag_service = RAGService(
        ingestion_service=ingestion_service,
        retrieval_service=retrieval_service,
        generation_service=generation_service,
    )
    context = rag_service.build_context_for_query(chunks, user_id="bob", group_ids=[])
    assert any(chunk.record_id == "1" for chunk in context)
    assert all(chunk.record_id != "2" for chunk in context)


def test_retrieval_uses_question_similarity_to_find_relevant_chunks() -> None:
    chunking = ChunkingService(chunk_size=200, chunk_overlap=20)
    embedding_service = MockEmbeddingService()
    ingestion_service = IngestionService(chunking_service=chunking, embedding_service=embedding_service)
    permission_service = PermissionService()
    retrieval_service = RetrievalService(permission_service=permission_service, embedding_service=embedding_service)
    generation_service = MockGenerationService()

    records = [
        SourceRecord(
            record_id="1",
            title="AWS Lambda overview",
            body="AWS Lambda is a serverless compute service that runs code without managing servers.",
            category="cloud",
            source_system="wiki",
            source_url="https://example.local/lambda",
            updated_at="2024-01-01",
            allowed_users=[],
            allowed_groups=[],
            is_public=True,
        ),
        SourceRecord(
            record_id="2",
            title="Kubernetes overview",
            body="Kubernetes is a container orchestration platform for managing distributed applications.",
            category="cloud",
            source_system="wiki",
            source_url="https://example.local/k8s",
            updated_at="2024-01-01",
            allowed_users=[],
            allowed_groups=[],
            is_public=True,
        ),
    ]

    chunks = []
    for record in records:
        text = ingestion_service.transform_record(record)
        chunks.extend(chunking.chunk_text(text, record_id=record.record_id, title=record.title, category=record.category, source_system=record.source_system, source_url=record.source_url, updated_at=record.updated_at, allowed_users=record.allowed_users, allowed_groups=record.allowed_groups, is_public=record.is_public))

    rag_service = RAGService(
        ingestion_service=ingestion_service,
        retrieval_service=retrieval_service,
        generation_service=generation_service,
    )

    context = rag_service.build_context_for_query(
        chunks,
        question="What is AWS Lambda?",
        user_id="bob",
        group_ids=[],
        top_k=1,
    )
    assert len(context) == 1
    assert context[0].record_id == "1"

    response = asyncio.run(
        rag_service.answer_query(
            chunks=chunks,
            question="What is AWS Lambda?",
            user_id="bob",
            group_ids=[],
            top_k=1,
        )
    )
    assert response.retrieved_chunk_count == 1
    assert response.sources[0].record_id == "1"

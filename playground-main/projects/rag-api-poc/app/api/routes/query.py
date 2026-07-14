from fastapi import APIRouter

from app.models.ingestion import SourceRecord
from app.models.query import QueryRequest, QueryResponse
from app.services.chunking_service import ChunkingService
from app.services.embedding_service import MockEmbeddingService
from app.services.generation_service import MockGenerationService
from app.services.ingestion_service import IngestionService
from app.services.permission_service import PermissionService
from app.services.rag_service import RAGService
from app.services.retrieval_service import RetrievalService

router = APIRouter()

_DEFAULT_CHUNKS: list | None = None


def _load_default_chunks() -> list:
    global _DEFAULT_CHUNKS
    if _DEFAULT_CHUNKS is not None:
        return _DEFAULT_CHUNKS

    chunking = ChunkingService(chunk_size=400, chunk_overlap=50)
    embedding_service = MockEmbeddingService()
    ingestion = IngestionService(chunking_service=chunking, embedding_service=embedding_service)
    records = [
        SourceRecord(
            record_id="aws-lambda",
            title="AWS Lambda overview",
            body="AWS Lambda is a serverless compute service that runs code without managing servers. It scales automatically and charges only for execution time.",
            category="cloud",
            source_system="wiki",
            source_url="https://example.local/aws-lambda",
            updated_at="2024-01-01",
            allowed_users=[],
            allowed_groups=[],
            is_public=True,
        ),
        SourceRecord(
            record_id="azure-functions",
            title="Azure Functions overview",
            body="Azure Functions is Microsoft's serverless compute offering for running event-driven code without provisioning infrastructure.",
            category="cloud",
            source_system="wiki",
            source_url="https://example.local/azure-functions",
            updated_at="2024-01-01",
            allowed_users=[],
            allowed_groups=[],
            is_public=True,
        ),
        SourceRecord(
            record_id="kubernetes",
            title="Kubernetes overview",
            body="Kubernetes is a container orchestration platform used to manage distributed applications and scale services reliably.",
            category="containers",
            source_system="wiki",
            source_url="https://example.local/kubernetes",
            updated_at="2024-01-01",
            allowed_users=[],
            allowed_groups=[],
            is_public=True,
        ),
    ]

    all_chunks = []
    for record in records:
        text = ingestion.transform_record(record)
        all_chunks.extend(
            chunking.chunk_text(
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
        )

    _DEFAULT_CHUNKS = all_chunks
    return _DEFAULT_CHUNKS


@router.post("/api/v1/query", response_model=QueryResponse)
async def query(request: QueryRequest) -> QueryResponse:
    chunking = ChunkingService(chunk_size=400, chunk_overlap=50)
    embedding_service = MockEmbeddingService()
    ingestion = IngestionService(chunking_service=chunking, embedding_service=embedding_service)
    permission = PermissionService()
    retrieval = RetrievalService(permission_service=permission, embedding_service=embedding_service)
    rag = RAGService(
        ingestion_service=ingestion,
        retrieval_service=retrieval,
        generation_service=MockGenerationService(),
    )
    chunks = _load_default_chunks()
    return await rag.answer_query(
        chunks=chunks,
        question=request.question,
        user_id=request.user_id,
        group_ids=request.group_ids,
        top_k=request.top_k or 3,
        category=request.category,
        source_system=request.source_system,
    )

from app.models.ingestion import SourceRecord
from app.services.chunking_service import ChunkingService
from app.services.ingestion_service import IngestionService


def test_transform_record_to_text() -> None:
    record = SourceRecord(
        record_id="123",
        title="Quarterly update",
        body="Summary of growth",
        category="finance",
        source_system="appian",
        source_url="https://example.local/123",
        updated_at="2024-01-01",
        allowed_users=["alice"],
        allowed_groups=["finance"],
        is_public=False,
    )
    service = IngestionService(chunking_service=ChunkingService(chunk_size=200, chunk_overlap=20))
    transformed = service.transform_record(record)
    assert "Title: Quarterly update" in transformed
    assert "Content: Summary of growth" in transformed


def test_chunk_overlap_and_ids() -> None:
    service = ChunkingService(chunk_size=30, chunk_overlap=10)
    text = "abcdefghij" * 3
    chunks = service.chunk_text(text, record_id="10", title="Test", category="x")
    assert len(chunks) >= 2
    assert chunks[0].chunk_id == "10-0"
    assert chunks[0].chunk_index == 0

from app.services.permission_service import PermissionService


def test_public_records_are_visible() -> None:
    service = PermissionService()
    assert service.is_visible(is_public=True, allowed_users=[], allowed_groups=[], user_id="bob", group_ids=[])


def test_allowed_user_can_access() -> None:
    service = PermissionService()
    assert service.is_visible(is_public=False, allowed_users=["alice"], allowed_groups=[], user_id="alice", group_ids=[])


def test_group_membership_allows_access() -> None:
    service = PermissionService()
    assert service.is_visible(is_public=False, allowed_users=[], allowed_groups=["finance"], user_id="bob", group_ids=["finance"])


def test_unauthorized_user_cannot_access() -> None:
    service = PermissionService()
    assert not service.is_visible(is_public=False, allowed_users=["alice"], allowed_groups=["finance"], user_id="bob", group_ids=["ops"])

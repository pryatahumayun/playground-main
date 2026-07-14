from __future__ import annotations


class PermissionService:
    def is_visible(
        self,
        *,
        is_public: bool,
        allowed_users: list[str],
        allowed_groups: list[str],
        user_id: str,
        group_ids: list[str],
    ) -> bool:
        if is_public:
            return True
        if user_id in allowed_users:
            return True
        return any(group in allowed_groups for group in group_ids)

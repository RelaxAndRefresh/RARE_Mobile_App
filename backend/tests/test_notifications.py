import pytest


@pytest.mark.asyncio
async def test_get_notifications_empty(client, test_user, auth_headers):
    response = await client.get("/api/v1/inbox/", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["notifications"] == []


@pytest.mark.asyncio
async def test_get_notifications(client, test_user, auth_headers, db):
    from app.db.models import Notification

    notif = Notification(
        user_id=test_user.id,
        notification_type="system",
        title="Welcome!",
        body="Welcome to RARE",
        is_read=False,
    )
    db.add(notif)
    db.commit()

    response = await client.get("/api/v1/inbox/", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert len(data["notifications"]) >= 1


@pytest.mark.asyncio
async def test_get_notifications_unread_only(client, test_user, auth_headers, db):
    from app.db.models import Notification

    notif_read = Notification(
        user_id=test_user.id,
        notification_type="system",
        title="Read Notification",
        body="Already read",
        is_read=True,
    )
    notif_unread = Notification(
        user_id=test_user.id,
        notification_type="alert",
        title="Unread Alert",
        body="Check this out",
        is_read=False,
    )
    db.add_all([notif_read, notif_unread])
    db.commit()

    response = await client.get(
        "/api/v1/inbox/",
        params={"unread_only": True},
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    for n in data["notifications"]:
        assert n["is_read"] is False


@pytest.mark.asyncio
async def test_mark_notification_read(client, test_user, auth_headers, db):
    from app.db.models import Notification

    notif = Notification(
        user_id=test_user.id,
        notification_type="system",
        title="Mark Me",
        body="This will be marked as read",
        is_read=False,
    )
    db.add(notif)
    db.commit()
    db.refresh(notif)

    response = await client.put(
        f"/api/v1/inbox/{notif.id}/read",
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "read"
    assert data["updated"] >= 1


@pytest.mark.asyncio
async def test_mark_notification_read_notifies_other_users(client, test_user, auth_headers, db):
    from app.db.models import User, Notification, CreditBalance
    from app.core.security import get_password_hash

    other = User(
        email="other_notif@example.com",
        name="Other Notif",
        password_hash=get_password_hash("Pass123!"),
        role="user",
        is_active=True,
    )
    db.add(other)
    db.flush()
    db.add(CreditBalance(user_id=other.id, balance=0))
    db.commit()
    db.refresh(other)

    other_notif = Notification(
        user_id=other.id,
        notification_type="system",
        title="Other's Notif",
        body="Not for test user",
        is_read=False,
    )
    db.add(other_notif)
    db.commit()
    db.refresh(other_notif)

    response = await client.put(
        f"/api/v1/inbox/{other_notif.id}/read",
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["updated"] == 0


@pytest.mark.asyncio
async def test_notifications_unauthenticated(client):
    response = await client.get("/api/v1/inbox/")
    assert response.status_code in [401, 403]

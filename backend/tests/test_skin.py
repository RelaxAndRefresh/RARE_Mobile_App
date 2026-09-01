import pytest


@pytest.mark.asyncio
async def test_create_skin_log(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/skin/log",
        json={
            "tags": ["breakout", "forehead"],
            "notes": "Small breakout on forehead",
            "rating": 6,
        },
        headers=auth_headers,
    )
    assert response.status_code == 201
    data = response.json()
    assert "breakout" in data["tags"]
    assert data["rating"] == 6
    assert data["notes"] == "Small breakout on forehead"


@pytest.mark.asyncio
async def test_create_skin_log_with_tags(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/skin/log",
        json={
            "tags": ["glowing", "hydrated", "clear"],
            "rating": 9,
        },
        headers=auth_headers,
    )
    assert response.status_code == 201
    data = response.json()
    assert len(data["tags"]) == 3


@pytest.mark.asyncio
async def test_get_timeline(client, test_user, auth_headers):
    await client.post(
        "/api/v1/skin/log",
        json={"tags": ["test"], "rating": 5},
        headers=auth_headers,
    )

    response = await client.get("/api/v1/skin/timeline", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert "logs" in data
    assert data["total"] >= 1
    assert data["page"] == 1


@pytest.mark.asyncio
async def test_get_timeline_empty(client, test_user, auth_headers):
    response = await client.get("/api/v1/skin/timeline", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["logs"] == []
    assert data["total"] == 0


@pytest.mark.asyncio
async def test_delete_skin_log_success(client, test_user, auth_headers):
    create_resp = await client.post(
        "/api/v1/skin/log",
        json={"tags": ["to_delete"], "rating": 3},
        headers=auth_headers,
    )
    log_id = create_resp.json()["id"]

    response = await client.delete(f"/api/v1/skin/{log_id}", headers=auth_headers)
    assert response.status_code == 200
    assert response.json()["status"] == "deleted"


@pytest.mark.asyncio
async def test_delete_skin_log_not_found(client, test_user, auth_headers):
    response = await client.delete("/api/v1/skin/99999", headers=auth_headers)
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_delete_skin_log_not_owner(client, test_user, auth_headers, db):
    from app.db.models import User, SkinLog, CreditBalance
    from app.core.security import get_password_hash

    other_user = User(
        email="other_skin@example.com",
        name="Other Skin",
        password_hash=get_password_hash("Pass123!"),
        role="user",
        is_active=True,
    )
    db.add(other_user)
    db.flush()
    db.add(CreditBalance(user_id=other_user.id, balance=0))
    db.commit()
    db.refresh(other_user)

    other_log = SkinLog(user_id=other_user.id, tags=["private"], rating=2)
    db.add(other_log)
    db.commit()
    db.refresh(other_log)

    response = await client.delete(f"/api/v1/skin/{other_log.id}", headers=auth_headers)
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_skin_unauthenticated(client):
    response = await client.get("/api/v1/skin/timeline")
    assert response.status_code in [401, 403]
